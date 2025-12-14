<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "cgo-basics" ); request.setAttribute("currentModule", "Advanced" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>CGO Basics in Go - Go Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Master CGO basics: call C code from Go, handle type conversions, manage memory, use callbacks, and configure builds for C integration.">
            <meta name="keywords"
                content="go cgo, golang c integration, cgo tutorial, go c interop, cgo memory management">

            <meta property="og:type" content="article">
            <meta property="og:title" content="CGO Basics in Go">
            <meta property="og:description" content="Learn to integrate C code with Go using CGO.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/go/cgo-basics.jsp">
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
    "name": "CGO Basics in Go",
    "description": "Learn to integrate C code with Go using CGO for performance and legacy code integration.",
    "learningResourceType": "Tutorial",
    "educationalLevel": "Advanced",
    "interactivityType": "active",
    "inLanguage": "en",
    "isAccessibleForFree": true,
    "url": "https://8gwifi.org/tutorials/go/cgo-basics.jsp",
    "teaches": ["CGO", "C Integration", "Type Conversion", "Memory Management", "Callbacks"],
    "timeRequired": "PT45M"
}
    </script>

            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="cgo-basics">
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
                                    <span>CGO Basics</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">CGO Basics</h1>
                                    <div class="lesson-meta">
                                        <span>Advanced</span>
                                        <span>~45 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">CGO enables Go programs to call C code and vice versa. This powerful
                                        feature
                                        allows you to leverage existing C libraries, optimize performance-critical
                                        sections, and
                                        integrate with legacy systems. Learn the fundamentals of CGO, from basic
                                        function calls to
                                        memory management and build configuration.</p>

                                    <!-- Section 1: What is CGO -->
                                    <h2>What is CGO?</h2>
                                    <p>CGO is a foreign function interface (FFI) that allows Go code to call C functions
                                        and use C
                                        types. It's built into the Go toolchain and requires a C compiler.</p>

                                    <div class="info-box">
                                        <strong>CGO Use Cases:</strong>
                                        <ul>
                                            <li><strong>Legacy Integration</strong> - Use existing C libraries</li>
                                            <li><strong>Performance</strong> - Optimize critical paths with C</li>
                                            <li><strong>System APIs</strong> - Access OS-specific C APIs</li>
                                            <li><strong>Hardware</strong> - Interface with device drivers</li>
                                        </ul>
                                    </div>

                                    <div class="warning-box">
                                        <strong>CGO Tradeoffs:</strong>
                                        <ul>
                                            <li>⚠️ Slower build times</li>
                                            <li>⚠️ Cross-compilation complexity</li>
                                            <li>⚠️ Debugging is harder</li>
                                            <li>⚠️ Memory management complexity</li>
                                            <li>⚠️ Not pure Go (loses some benefits)</li>
                                        </ul>
                                    </div>

                                    <!-- Section 2: Hello CGO -->
                                    <h2>Hello CGO</h2>
                                    <p>The basic CGO syntax uses a special comment block before <code>import "C"</code>:
                                    </p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="go/cgo-hello.go" />
                                        <jsp:param name="language" value="go" />
                                        <jsp:param name="editorId" value="compiler-cgo-hello" />
                                    </jsp:include>

                                    <div class="tip-box">
                                        <strong>CGO Syntax Rules:</strong>
                                        <ul>
                                            <li>C code goes in comment block before <code>import "C"</code></li>
                                            <li>No blank line between comment and import</li>
                                            <li>Prefix C functions with <code>C.</code></li>
                                            <li>Use <code>#include</code> for C headers</li>
                                        </ul>
                                    </div>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <!-- Section 3: Type Conversions -->
                                    <h2>Type Conversions</h2>
                                    <p>Converting between Go and C types requires explicit conversions:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="go/cgo-types.go" />
                                        <jsp:param name="language" value="go" />
                                        <jsp:param name="editorId" value="compiler-cgo-types" />
                                    </jsp:include>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Go Type</th>
                                                <th>C Type</th>
                                                <th>Conversion</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>int</td>
                                                <td>int</td>
                                                <td>C.int(x)</td>
                                            </tr>
                                            <tr>
                                                <td>int32</td>
                                                <td>int32_t</td>
                                                <td>C.int32_t(x)</td>
                                            </tr>
                                            <tr>
                                                <td>int64</td>
                                                <td>int64_t</td>
                                                <td>C.int64_t(x)</td>
                                            </tr>
                                            <tr>
                                                <td>float32</td>
                                                <td>float</td>
                                                <td>C.float(x)</td>
                                            </tr>
                                            <tr>
                                                <td>float64</td>
                                                <td>double</td>
                                                <td>C.double(x)</td>
                                            </tr>
                                            <tr>
                                                <td>string</td>
                                                <td>char*</td>
                                                <td>C.CString(s)</td>
                                            </tr>
                                            <tr>
                                                <td>[]byte</td>
                                                <td>void*</td>
                                                <td>C.CBytes(b)</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <!-- Section 4: String Handling -->
                                    <h2>String Handling</h2>
                                    <p>Strings require special care because Go strings are immutable and C strings are
                                        null-terminated:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="go/cgo-strings.go" />
                                        <jsp:param name="language" value="go" />
                                        <jsp:param name="editorId" value="compiler-cgo-strings" />
                                    </jsp:include>

                                    <div class="best-practice-box">
                                        <strong>String Conversion Functions:</strong>
                                        <ul>
                                            <li><code>C.CString(s)</code> - Go string → C char* (allocates, must free)
                                            </li>
                                            <li><code>C.GoString(cs)</code> - C char* → Go string (copies)</li>
                                            <li><code>C.GoStringN(cs, n)</code> - C char* → Go string (with length)</li>
                                            <li><code>C.CBytes(b)</code> - Go []byte → C void* (allocates, must free)
                                            </li>
                                            <li><code>C.GoBytes(p, n)</code> - C void* → Go []byte (copies)</li>
                                        </ul>
                                    </div>

                                    <!-- Section 5: Callbacks -->
                                    <h2>Callbacks</h2>
                                    <p>Go functions can be called from C using the <code>//export</code> directive:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="go/cgo-callbacks.go" />
                                        <jsp:param name="language" value="go" />
                                        <jsp:param name="editorId" value="compiler-cgo-callbacks" />
                                    </jsp:include>

                                    <div class="warning-box">
                                        <strong>Callback Restrictions:</strong>
                                        <ul>
                                            <li>Exported functions must use C types</li>
                                            <li>Cannot call Go functions that allocate</li>
                                            <li>Cannot use goroutines</li>
                                            <li>Cannot panic</li>
                                            <li>Keep callbacks simple and fast</li>
                                        </ul>
                                    </div>

                                    <!-- Section 6: Memory Management -->
                                    <h2>Memory Management</h2>
                                    <p>Understanding memory ownership is critical when using CGO:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="go/cgo-memory.go" />
                                        <jsp:param name="language" value="go" />
                                        <jsp:param name="editorId" value="compiler-cgo-memory" />
                                    </jsp:include>

                                    <div class="best-practice-box">
                                        <strong>Memory Rules:</strong>
                                        <ul>
                                            <li>✓ C-allocated memory must be freed with <code>C.free()</code></li>
                                            <li>✓ <code>C.CString()</code> allocates - always free</li>
                                            <li>✓ <code>C.CBytes()</code> allocates - always free</li>
                                            <li>✓ <code>C.GoString()</code> copies - no free needed</li>
                                            <li>✓ Don't pass Go pointers to C that outlive the call</li>
                                            <li>✓ Don't store Go pointers in C memory</li>
                                        </ul>
                                    </div>

                                    <!-- Section 7: Build Configuration -->
                                    <h2>Build Configuration</h2>
                                    <p>Use <code>#cgo</code> directives to configure the C compiler and linker:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="go/cgo-build.go" />
                                        <jsp:param name="language" value="go" />
                                        <jsp:param name="editorId" value="compiler-cgo-build" />
                                    </jsp:include>

                                    <div class="info-box">
                                        <strong>Common #cgo Directives:</strong>
                                        <pre><code class="language-go">// Compiler flags
#cgo CFLAGS: -Wall -O2 -I/usr/local/include

// Linker flags
#cgo LDFLAGS: -L/usr/local/lib -lmylib

// Platform-specific
#cgo linux CFLAGS: -D_GNU_SOURCE
#cgo darwin LDFLAGS: -framework CoreFoundation
#cgo windows LDFLAGS: -lws2_32

// Package config
#cgo pkg-config: gtk+-3.0</code></pre>
                                    </div>

                                    <!-- Common Mistakes -->
                                    <h2>Common Mistakes</h2>

                                    <div class="mistake-box">
                                        <h4>1. Forgetting to free C memory</h4>
                                        <pre><code class="language-go">// ❌ Wrong - memory leak
func bad() {
    s := C.CString("hello")
    // Forgot to free!
}

// ✅ Correct - always free
func good() {
    s := C.CString("hello")
    defer C.free(unsafe.Pointer(s))
    // Use s...
}</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>2. Passing Go pointers incorrectly</h4>
                                        <pre><code class="language-go">// ❌ Wrong - Go pointer stored in C
var globalPtr *C.char
func bad() {
    s := "hello"
    globalPtr = C.CString(s) // Dangerous!
}

// ✅ Correct - manage lifetime properly
func good() {
    s := C.CString("hello")
    defer C.free(unsafe.Pointer(s))
    // Use s within this scope
}</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>3. Blank line before import "C"</h4>
                                        <pre><code class="language-go">// ❌ Wrong - blank line breaks CGO
/*
#include <stdio.h>
*/

import "C" // Error!

// ✅ Correct - no blank line
/*
#include <stdio.h>
*/
import "C" // Works!</code></pre>
                                    </div>

                                    <!-- Exercise -->
                                    <h2>Exercise: C Library Wrapper</h2>
                                    <div class="exercise-section">
                                        <p><strong>Task:</strong> Create a Go wrapper for a simple C math library.</p>

                                        <p><strong>Requirements:</strong></p>
                                        <ul>
                                            <li>C functions for basic math operations</li>
                                            <li>Go wrapper with proper error handling</li>
                                            <li>Memory management</li>
                                            <li>Type conversions</li>
                                        </ul>

                                        <details class="exercise-hint">
                                            <summary>Show Solution</summary>
                                            <pre><code class="language-go">package main

/*
#include <math.h>
#include <stdlib.h>

typedef struct {
    double result;
    int error;
} MathResult;

MathResult safe_divide(double a, double b) {
    MathResult r;
    if (b == 0.0) {
        r.error = 1;
        r.result = 0.0;
    } else {
        r.error = 0;
        r.result = a / b;
    }
    return r;
}

double* create_array(int size) {
    return (double*)malloc(size * sizeof(double));
}

void fill_array(double* arr, int size) {
    for (int i = 0; i < size; i++) {
        arr[i] = sqrt((double)i);
    }
}
*/
import "C"
import (
    "fmt"
    "unsafe"
)

// SafeDivide wraps C division with error handling
func SafeDivide(a, b float64) (float64, error) {
    result := C.safe_divide(C.double(a), C.double(b))
    
    if result.error != 0 {
        return 0, fmt.Errorf("division by zero")
    }
    
    return float64(result.result), nil
}

// CalculateSquareRoots creates array of square roots
func CalculateSquareRoots(n int) []float64 {
    // Allocate C array
    cArray := C.create_array(C.int(n))
    defer C.free(unsafe.Pointer(cArray))
    
    // Fill with values
    C.fill_array(cArray, C.int(n))
    
    // Convert to Go slice
    goSlice := make([]float64, n)
    cSlice := (*[1 << 30]C.double)(unsafe.Pointer(cArray))[:n:n]
    
    for i := 0; i < n; i++ {
        goSlice[i] = float64(cSlice[i])
    }
    
    return goSlice
}

func main() {
    // Test division
    result, err := SafeDivide(10, 2)
    if err != nil {
        fmt.Println("Error:", err)
    } else {
        fmt.Printf("10 / 2 = %.2f\n", result)
    }
    
    // Test division by zero
    _, err = SafeDivide(10, 0)
    if err != nil {
        fmt.Println("Error:", err)
    }
    
    // Test array
    roots := CalculateSquareRoots(5)
    fmt.Println("Square roots:", roots)
}</code></pre>
                                        </details>
                                    </div>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>CGO</strong> enables Go to call C code</li>
                                            <li><strong>import "C"</strong> provides access to C functions</li>
                                            <li><strong>Type conversions</strong> are explicit (C.int, C.CString)</li>
                                            <li><strong>Memory management</strong> is critical - always free C memory
                                            </li>
                                            <li><strong>C.CString()</strong> allocates, must free with C.free()</li>
                                            <li><strong>C.GoString()</strong> copies, no free needed</li>
                                            <li><strong>//export</strong> allows C to call Go functions</li>
                                            <li><strong>#cgo directives</strong> configure compiler and linker</li>
                                            <li><strong>Build tags</strong> control conditional compilation</li>
                                            <li><strong>Tradeoffs</strong> - power vs complexity</li>
                                        </ul>
                                    </div>

                                    <!-- What's Next -->
                                    <h2>What's Next?</h2>
                                    <p>You've learned CGO basics! While powerful, CGO should be used judiciously. Next,
                                        you'll
                                        explore the <strong>unsafe package</strong>, which provides low-level memory
                                        operations and
                                        type conversions that bypass Go's type safety - use with extreme caution!</p>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="escape-analysis.jsp" />
                                    <jsp:param name="prevTitle" value="Escape Analysis" />
                                    <jsp:param name="nextLink" value="unsafe-package.jsp" />
                                    <jsp:param name="nextTitle" value="Unsafe Package" />
                                    <jsp:param name="currentLessonId" value="cgo-basics" />
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