<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "unsafe-package" ); request.setAttribute("currentModule", "Advanced" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Unsafe Package in Go - Go Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Master Go's unsafe package: pointer operations, type conversions, memory manipulation, and performance optimization. Learn when and how to use unsafe code safely.">
            <meta name="keywords"
                content="go unsafe package, golang unsafe, pointer arithmetic, zero-copy, memory manipulation, performance optimization">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Unsafe Package in Go">
            <meta property="og:description"
                content="Learn Go's unsafe package for low-level programming and optimization.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/go/unsafe-package.jsp">
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
    "name": "Unsafe Package in Go",
    "description": "Learn Go's unsafe package for low-level memory operations and performance optimization.",
    "learningResourceType": "Tutorial",
    "educationalLevel": "Advanced",
    "interactivityType": "active",
    "inLanguage": "en",
    "isAccessibleForFree": true,
    "url": "https://8gwifi.org/tutorials/go/unsafe-package.jsp",
    "teaches": ["Unsafe Package", "Pointer Operations", "Memory Manipulation", "Zero-Copy", "Performance"],
    "timeRequired": "PT40M"
}
    </script>

            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="unsafe-package">
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
                                    <span>Unsafe Package</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Unsafe Package</h1>
                                    <div class="lesson-meta">
                                        <span>Advanced</span>
                                        <span>~40 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">The <code>unsafe</code> package provides low-level operations that
                                        bypass Go's
                                        type safety. While powerful for optimization and system programming, it requires
                                        extreme care.
                                        Learn when to use unsafe, how to use it correctly, and understand the risks
                                        involved.</p>

                                    <div class="warning-box">
                                        <strong>⚠️ Critical Warning:</strong>
                                        <ul>
                                            <li>Unsafe code bypasses Go's type safety</li>
                                            <li>Can cause crashes, data corruption, and security issues</li>
                                            <li>Not protected by Go's compatibility promise</li>
                                            <li>Should be used only when absolutely necessary</li>
                                            <li>Requires thorough testing and documentation</li>
                                        </ul>
                                    </div>

                                    <!-- Section 1: What is Unsafe -->
                                    <h2>What is the Unsafe Package?</h2>
                                    <p>The <code>unsafe</code> package provides operations that step around Go's type
                                        safety. It's
                                        used for low-level programming, performance optimization, and interfacing with
                                        non-Go code.</p>

                                    <div class="info-box">
                                        <strong>Unsafe Package Functions:</strong>
                                        <ul>
                                            <li><code>Sizeof(x)</code> - Returns size of x in bytes</li>
                                            <li><code>Alignof(x)</code> - Returns alignment of x</li>
                                            <li><code>Offsetof(x.f)</code> - Returns offset of field f in struct x</li>
                                            <li><code>Pointer</code> - Generic pointer type</li>
                                        </ul>
                                    </div>

                                    <!-- Section 2: Pointer Operations -->
                                    <h2>Pointer Operations</h2>
                                    <p>Unsafe pointers allow arbitrary pointer arithmetic and type conversions:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="go/unsafe-pointer.go" />
                                        <jsp:param name="language" value="go" />
                                        <jsp:param name="editorId" value="compiler-unsafe-pointer" />
                                    </jsp:include>

                                    <div class="tip-box">
                                        <strong>Pointer Conversion Rules:</strong>
                                        <ul>
                                            <li><code>*T</code> → <code>unsafe.Pointer</code> → <code>*U</code></li>
                                            <li><code>unsafe.Pointer</code> → <code>uintptr</code> (for arithmetic)</li>
                                            <li><code>uintptr</code> → <code>unsafe.Pointer</code> (back to pointer)
                                            </li>
                                            <li>Never store <code>uintptr</code> - GC won't track it</li>
                                        </ul>
                                    </div>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <!-- Section 3: Type Conversions -->
                                    <h2>Type Conversions</h2>
                                    <p>Unsafe allows zero-copy conversions between compatible types:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="go/unsafe-conversion.go" />
                                        <jsp:param name="language" value="go" />
                                        <jsp:param name="editorId" value="compiler-unsafe-conversion" />
                                    </jsp:include>

                                    <div class="best-practice-box">
                                        <strong>Zero-Copy Conversions:</strong>
                                        <ul>
                                            <li>String ↔ []byte without copying</li>
                                            <li>Reinterpret bits (float ↔ int)</li>
                                            <li>Struct type conversions</li>
                                            <li>Interface to concrete type</li>
                                        </ul>
                                    </div>

                                    <!-- Section 4: Memory Operations -->
                                    <h2>Memory Operations</h2>
                                    <p>Direct memory manipulation for layout and performance:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="go/unsafe-memory.go" />
                                        <jsp:param name="language" value="go" />
                                        <jsp:param name="editorId" value="compiler-unsafe-memory" />
                                    </jsp:include>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Type</th>
                                                <th>Size (bytes)</th>
                                                <th>Alignment</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>bool</td>
                                                <td>1</td>
                                                <td>1</td>
                                            </tr>
                                            <tr>
                                                <td>int8, uint8</td>
                                                <td>1</td>
                                                <td>1</td>
                                            </tr>
                                            <tr>
                                                <td>int16, uint16</td>
                                                <td>2</td>
                                                <td>2</td>
                                            </tr>
                                            <tr>
                                                <td>int32, uint32, float32</td>
                                                <td>4</td>
                                                <td>4</td>
                                            </tr>
                                            <tr>
                                                <td>int64, uint64, float64</td>
                                                <td>8</td>
                                                <td>8</td>
                                            </tr>
                                            <tr>
                                                <td>pointer</td>
                                                <td>8 (64-bit)</td>
                                                <td>8</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <!-- Section 5: Struct Operations -->
                                    <h2>Struct Field Access</h2>
                                    <p>Access struct fields by offset for optimization:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="go/unsafe-struct.go" />
                                        <jsp:param name="language" value="go" />
                                        <jsp:param name="editorId" value="compiler-unsafe-struct" />
                                    </jsp:include>

                                    <div class="info-box">
                                        <strong>Struct Packing Tips:</strong>
                                        <ul>
                                            <li>Order fields by size (largest first)</li>
                                            <li>Group related fields together</li>
                                            <li>Use <code>Sizeof()</code> to check total size</li>
                                            <li>Use <code>Offsetof()</code> to verify layout</li>
                                            <li>Consider cache line alignment (64 bytes)</li>
                                        </ul>
                                    </div>

                                    <!-- Section 6: Performance -->
                                    <h2>Performance Optimization</h2>
                                    <p>Benchmark unsafe vs safe operations:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="go/unsafe-performance.go" />
                                        <jsp:param name="language" value="go" />
                                        <jsp:param name="editorId" value="compiler-unsafe-performance" />
                                    </jsp:include>

                                    <div class="best-practice-box">
                                        <strong>When to Use Unsafe:</strong>
                                        <ul>
                                            <li>✓ Zero-copy string/byte conversions in hot paths</li>
                                            <li>✓ Low-level system programming</li>
                                            <li>✓ Interfacing with C libraries</li>
                                            <li>✓ Performance-critical code (after profiling)</li>
                                            <li>✓ Implementing data structures</li>
                                        </ul>
                                    </div>

                                    <div class="warning-box">
                                        <strong>When NOT to Use Unsafe:</strong>
                                        <ul>
                                            <li>❌ Regular application code</li>
                                            <li>❌ Without profiling first</li>
                                            <li>❌ In public APIs</li>
                                            <li>❌ When safe alternatives exist</li>
                                            <li>❌ Without thorough testing</li>
                                        </ul>
                                    </div>

                                    <!-- Common Mistakes -->
                                    <h2>Common Mistakes</h2>

                                    <div class="mistake-box">
                                        <h4>1. Storing uintptr instead of unsafe.Pointer</h4>
                                        <pre><code class="language-go">// ❌ Wrong - GC won't track uintptr
type Bad struct {
    ptr uintptr // Can become invalid!
}

// ✅ Correct - GC tracks unsafe.Pointer
type Good struct {
    ptr unsafe.Pointer
}</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>2. Modifying string bytes</h4>
                                        <pre><code class="language-go">// ❌ Wrong - strings are immutable
s := "hello"
bytes := *(*[]byte)(unsafe.Pointer(&s))
bytes[0] = 'H' // Undefined behavior!

// ✅ Correct - create new string
bytes := []byte(s)
bytes[0] = 'H'
s = string(bytes)</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>3. Ignoring alignment requirements</h4>
                                        <pre><code class="language-go">// ❌ Wrong - may cause crash on some platforms
bytes := []byte{1, 2, 3, 4, 5, 6, 7, 8}
ptr := (*int64)(unsafe.Pointer(&bytes[1])) // Misaligned!

// ✅ Correct - ensure proper alignment
ptr := (*int64)(unsafe.Pointer(&bytes[0])) // Aligned</code></pre>
                                    </div>

                                    <!-- Exercise -->
                                    <h2>Exercise: Zero-Copy String Builder</h2>
                                    <div class="exercise-section">
                                        <p><strong>Task:</strong> Build a string builder using unsafe for zero-copy
                                            operations.</p>

                                        <p><strong>Requirements:</strong></p>
                                        <ul>
                                            <li>Append strings without copying</li>
                                            <li>Convert to final string efficiently</li>
                                            <li>Handle edge cases safely</li>
                                            <li>Benchmark against strings.Builder</li>
                                        </ul>

                                        <details class="exercise-hint">
                                            <summary>Show Solution</summary>
                                            <pre><code class="language-go">package main

import (
    "fmt"
    "strings"
    "time"
    "unsafe"
)

// StringHeader for unsafe string operations
type StringHeader struct {
    Data uintptr
    Len  int
}

// SliceHeader for unsafe slice operations
type SliceHeader struct {
    Data uintptr
    Len  int
    Cap  int
}

// UnsafeBuilder builds strings using unsafe operations
type UnsafeBuilder struct {
    buf []byte
}

// NewUnsafeBuilder creates a new builder
func NewUnsafeBuilder(capacity int) *UnsafeBuilder {
    return &UnsafeBuilder{
        buf: make([]byte, 0, capacity),
    }
}

// Append adds a string without copying
func (b *UnsafeBuilder) Append(s string) {
    // Convert string to []byte without copying
    strHeader := (*StringHeader)(unsafe.Pointer(&s))
    bytes := *(*[]byte)(unsafe.Pointer(&SliceHeader{
        Data: strHeader.Data,
        Len:  strHeader.Len,
        Cap:  strHeader.Len,
    }))
    
    // Append to buffer
    b.buf = append(b.buf, bytes...)
}

// String returns the final string
func (b *UnsafeBuilder) String() string {
    // Convert []byte to string without copying
    sliceHeader := (*SliceHeader)(unsafe.Pointer(&b.buf))
    return *(*string)(unsafe.Pointer(&StringHeader{
        Data: sliceHeader.Data,
        Len:  sliceHeader.Len,
    }))
}

func main() {
    // Test correctness
    fmt.Println("Testing UnsafeBuilder:")
    builder := NewUnsafeBuilder(100)
    builder.Append("Hello, ")
    builder.Append("unsafe ")
    builder.Append("world!")
    result := builder.String()
    fmt.Printf("Result: %s\n\n", result)
    
    // Benchmark
    iterations := 100000
    parts := []string{"Hello, ", "this ", "is ", "a ", "test!"}
    
    // strings.Builder
    start := time.Now()
    for i := 0; i < iterations; i++ {
        var sb strings.Builder
        for _, p := range parts {
            sb.WriteString(p)
        }
        _ = sb.String()
    }
    safeDuration := time.Since(start)
    
    // UnsafeBuilder
    start = time.Now()
    for i := 0; i < iterations; i++ {
        ub := NewUnsafeBuilder(50)
        for _, p := range parts {
            ub.Append(p)
        }
        _ = ub.String()
    }
    unsafeDuration := time.Since(start)
    
    fmt.Println("Benchmark results:")
    fmt.Printf("strings.Builder: %v\n", safeDuration)
    fmt.Printf("UnsafeBuilder:   %v\n", unsafeDuration)
    fmt.Printf("Speedup:         %.2fx\n", float64(safeDuration)/float64(unsafeDuration))
}</code></pre>
                                        </details>
                                    </div>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>unsafe package</strong> bypasses Go's type safety</li>
                                            <li><strong>Sizeof()</strong> returns size in bytes</li>
                                            <li><strong>Alignof()</strong> returns alignment requirement</li>
                                            <li><strong>Offsetof()</strong> returns field offset in struct</li>
                                            <li><strong>unsafe.Pointer</strong> is a generic pointer type</li>
                                            <li><strong>uintptr</strong> for pointer arithmetic (temporary only)</li>
                                            <li><strong>Zero-copy</strong> conversions possible</li>
                                            <li><strong>Struct packing</strong> reduces memory usage</li>
                                            <li><strong>Performance gains</strong> in critical paths</li>
                                            <li><strong>Use sparingly</strong> and document thoroughly</li>
                                        </ul>
                                    </div>

                                    <!-- What's Next -->
                                    <h2>What's Next?</h2>
                                    <p>You've learned the unsafe package! While powerful, remember that with great power
                                        comes great
                                        responsibility. Next, you'll explore <strong>compiler and linker flags</strong>
                                        to optimize
                                        your Go builds, control compilation, and fine-tune performance.</p>
                                </div>

                                <script
                                    src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror.min.js"></script>
                                <script
                                    src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-simple.min.js"></script>
                                <script
                                    src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/go.min.js"></script>
                                <script src="<%=request.getContextPath()%>/tutorials/assets/js/progress.js"></script>
                                <script
                                    src="<%=request.getContextPath()%>/tutorials/assets/js/tutorial-core.js?v=4"></script>
        </body>

        </html>