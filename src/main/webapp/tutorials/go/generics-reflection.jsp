<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "generics-reflection" ); request.setAttribute("currentModule", "Advanced"
        ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Generics & Reflection - Go Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Master Go generics (1.18+) and reflection. Learn type parameters, constraints, generic functions, and runtime type inspection with interactive examples.">
            <meta name="keywords"
                content="go generics, golang generics, go reflection, type parameters, constraints, go 1.18, reflect package">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Generics & Reflection in Go">
            <meta property="og:description"
                content="Learn modern Go generics and reflection for flexible, type-safe code.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/go/generics-reflection.jsp">
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
    "name": "Generics & Reflection in Go",
    "description": "Learn Go generics (1.18+) and reflection for flexible, type-safe code.",
    "learningResourceType": "Tutorial",
    "educationalLevel": "Advanced",
    "interactivityType": "active",
    "inLanguage": "en",
    "isAccessibleForFree": true,
    "url": "https://8gwifi.org/tutorials/go/generics-reflection.jsp",
    "teaches": ["Generics", "Type Parameters", "Constraints", "Reflection", "Type Inspection"],
    "timeRequired": "PT50M"
}
    </script>

            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="generics-reflection">
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
                                    <span>Generics & Reflection</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Generics & Reflection</h1>
                                    <div class="lesson-meta">
                                        <span>Advanced</span>
                                        <span>~50 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">Go 1.18 introduced generics, enabling type-safe code reuse without
                                        sacrificing
                                        performance. Combined with reflection for runtime type inspection, these
                                        features provide
                                        powerful tools for building flexible, maintainable applications. Master both to
                                        write modern,
                                        idiomatic Go code.</p>

                                    <div class="diagram-container">
                                        <img src="<%=request.getContextPath()%>/tutorials/assets/images/go-generics.svg"
                                            alt="Generics in Go - Type Parameters and Constraints"
                                            class="tutorial-diagram"
                                            style="max-width: 100%; height: auto; margin: 2rem 0;" />
                                        <p class="diagram-caption">Figure: Go Generics - Type Parameters, Generic
                                            Functions, Types, and Constraints</p>
                                    </div>

                                    <!-- Section 1: Generics Basics -->
                                    <h2>Introduction to Generics</h2>
                                    <p>Generics allow you to write functions and types that work with any type while
                                        maintaining type
                                        safety. The syntax uses square brackets <code>[T any]</code> for type
                                        parameters:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="go/generics-basic.go" />
                                        <jsp:param name="language" value="go" />
                                        <jsp:param name="editorId" value="compiler-generics-basic" />
                                    </jsp:include>

                                    <div class="info-box">
                                        <strong>Type Parameter Syntax:</strong>
                                        <ul>
                                            <li><code>[T any]</code> - T is the type parameter, any is the constraint
                                            </li>
                                            <li><code>any</code> - Built-in constraint meaning "any type" (alias for
                                                interface{})</li>
                                            <li>Type inference - Go can often infer T from arguments</li>
                                        </ul>
                                    </div>

                                    <!-- Section 2: Generic Functions -->
                                    <h2>Generic Functions</h2>
                                    <p>Generic functions can work with multiple types and transform data type-safely:
                                    </p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="go/generics-functions.go" />
                                        <jsp:param name="language" value="go" />
                                        <jsp:param name="editorId" value="compiler-generics-functions" />
                                    </jsp:include>

                                    <div class="best-practice-box">
                                        <strong>When to Use Generics:</strong>
                                        <ul>
                                            <li>Data structures (stacks, queues, trees)</li>
                                            <li>Algorithms (sorting, searching, mapping)</li>
                                            <li>Utility functions (Min, Max, Filter, Map)</li>
                                            <li>When you'd otherwise use interface{} with type assertions</li>
                                        </ul>
                                    </div>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <!-- Section 3: Generic Types -->
                                    <h2>Generic Types</h2>
                                    <p>Create reusable data structures that work with any type:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="go/generics-types.go" />
                                        <jsp:param name="language" value="go" />
                                        <jsp:param name="editorId" value="compiler-generics-types" />
                                    </jsp:include>

                                    <div class="tip-box">
                                        <strong>Pro Tip:</strong> Generic types are instantiated with specific types
                                        like
                                        <code>Stack[int]</code> or <code>Stack[string]</code>. Each instantiation
                                        creates a
                                        separate type.
                                    </div>

                                    <!-- Section 4: Constraints -->
                                    <h2>Type Constraints</h2>
                                    <p>Constraints limit which types can be used with generics:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="go/generics-constraints.go" />
                                        <jsp:param name="language" value="go" />
                                        <jsp:param name="editorId" value="compiler-constraints" />
                                    </jsp:include>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Constraint</th>
                                                <th>Package</th>
                                                <th>Description</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><code>any</code></td>
                                                <td>Built-in</td>
                                                <td>Any type (alias for interface{})</td>
                                            </tr>
                                            <tr>
                                                <td><code>comparable</code></td>
                                                <td>Built-in</td>
                                                <td>Types that support == and !=</td>
                                            </tr>
                                            <tr>
                                                <td><code>constraints.Ordered</code></td>
                                                <td>golang.org/x/exp/constraints</td>
                                                <td>Types that support &lt;, &gt;, &lt;=, &gt;=</td>
                                            </tr>
                                            <tr>
                                                <td>Custom</td>
                                                <td>Your code</td>
                                                <td>Interface with type union</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <!-- Section 5: Reflection Basics -->
                                    <h2>Reflection Basics</h2>
                                    <p>The <code>reflect</code> package provides runtime type inspection:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="go/reflection-basic.go" />
                                        <jsp:param name="language" value="go" />
                                        <jsp:param name="editorId" value="compiler-reflection" />
                                    </jsp:include>

                                    <div class="info-box">
                                        <strong>Reflection Concepts:</strong>
                                        <ul>
                                            <li><code>reflect.TypeOf()</code> - Get type information</li>
                                            <li><code>reflect.ValueOf()</code> - Get value information</li>
                                            <li><code>Type.Kind()</code> - Get underlying kind (struct, int, etc.)</li>
                                            <li><code>Type.Field()</code> - Access struct fields</li>
                                            <li><code>Field.Tag</code> - Read struct tags</li>
                                        </ul>
                                    </div>

                                    <!-- Section 6: Advanced Reflection -->
                                    <h2>Advanced Reflection</h2>
                                    <p>Reflection enables dynamic method calls and field modification:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="go/reflection-advanced.go" />
                                        <jsp:param name="language" value="go" />
                                        <jsp:param name="editorId" value="compiler-reflection-advanced" />
                                    </jsp:include>

                                    <div class="warning-box">
                                        <strong>Reflection Performance:</strong> Reflection is slower than direct code.
                                        Use it when
                                        flexibility is more important than performance (serialization, ORMs, dependency
                                        injection).
                                    </div>

                                    <!-- Generics vs Reflection -->
                                    <h2>Generics vs Reflection</h2>
                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Aspect</th>
                                                <th>Generics</th>
                                                <th>Reflection</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>Type Safety</td>
                                                <td>✅ Compile-time</td>
                                                <td>❌ Runtime only</td>
                                            </tr>
                                            <tr>
                                                <td>Performance</td>
                                                <td>✅ Fast (no overhead)</td>
                                                <td>⚠️ Slower</td>
                                            </tr>
                                            <tr>
                                                <td>Flexibility</td>
                                                <td>⚠️ Limited to constraints</td>
                                                <td>✅ Very flexible</td>
                                            </tr>
                                            <tr>
                                                <td>Use Case</td>
                                                <td>Data structures, algorithms</td>
                                                <td>Serialization, ORMs, DI</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <!-- Common Mistakes -->
                                    <h2>Common Mistakes</h2>

                                    <div class="mistake-box">
                                        <h4>1. Over-using generics</h4>
                                        <pre><code class="language-go">// ❌ Wrong - generics not needed
func AddInts[T int](a, b T) T {
    return a + b
}

// ✅ Correct - just use int
func AddInts(a, b int) int {
    return a + b
}</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>2. Forgetting to check CanSet() in reflection</h4>
                                        <pre><code class="language-go">// ❌ Wrong - will panic
v := reflect.ValueOf(myStruct)
v.FieldByName("Name").SetString("Alice")

// ✅ Correct - use pointer and check
v := reflect.ValueOf(&myStruct).Elem()
field := v.FieldByName("Name")
if field.CanSet() {
    field.SetString("Alice")
}</code></pre>
                                    </div>

                                    <!-- Exercise -->
                                    <h2>Exercise: Generic Cache with Reflection</h2>
                                    <div class="exercise-section">
                                        <p><strong>Task:</strong> Build a generic cache that uses reflection to validate
                                            stored values.</p>

                                        <p><strong>Requirements:</strong></p>
                                        <ul>
                                            <li>Generic Cache[K comparable, V any] type</li>
                                            <li>Get/Set methods</li>
                                            <li>Use reflection to log type information</li>
                                            <li>Validate that keys are comparable</li>
                                        </ul>

                                        <details class="exercise-hint">
                                            <summary>Show Solution</summary>
                                            <pre><code class="language-go">package main

import (
    "fmt"
    "reflect"
    "sync"
)

type Cache[K comparable, V any] struct {
    mu    sync.RWMutex
    items map[K]V
}

func NewCache[K comparable, V any]() *Cache[K, V] {
    c := &Cache[K, V]{
        items: make(map[K]V),
    }
    
    // Log type information using reflection
    var k K
    var v V
    fmt.Printf("Created cache with key type: %v, value type: %v\n",
        reflect.TypeOf(k), reflect.TypeOf(v))
    
    return c
}

func (c *Cache[K, V]) Set(key K, value V) {
    c.mu.Lock()
    defer c.mu.Unlock()
    
    // Use reflection to log value details
    vType := reflect.TypeOf(value)
    vValue := reflect.ValueOf(value)
    fmt.Printf("Setting key=%v, value type=%v, kind=%v\n",
        key, vType, vValue.Kind())
    
    c.items[key] = value
}

func (c *Cache[K, V]) Get(key K) (V, bool) {
    c.mu.RLock()
    defer c.mu.RUnlock()
    
    value, ok := c.items[key]
    return value, ok
}

func main() {
    // String -> int cache
    cache1 := NewCache[string, int]()
    cache1.Set("age", 25)
    cache1.Set("score", 100)
    
    if age, ok := cache1.Get("age"); ok {
        fmt.Printf("Age: %d\n", age)
    }
    
    // Int -> struct cache
    type Person struct {
        Name string
        Age  int
    }
    
    cache2 := NewCache[int, Person]()
    cache2.Set(1, Person{"Alice", 25})
    cache2.Set(2, Person{"Bob", 30})
    
    if person, ok := cache2.Get(1); ok {
        fmt.Printf("Person: %+v\n", person)
    }
}</code></pre>
                                        </details>
                                    </div>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>Generics (Go 1.18+)</strong> enable type-safe code reuse</li>
                                            <li><strong>Type parameters</strong> use syntax [T any]</li>
                                            <li><strong>Constraints</strong> limit which types can be used</li>
                                            <li><strong>Type inference</strong> often eliminates need to specify types
                                            </li>
                                            <li><strong>Generic types</strong> create reusable data structures</li>
                                            <li><strong>Reflection</strong> provides runtime type inspection</li>
                                            <li><strong>reflect.TypeOf()</strong> gets type information</li>
                                            <li><strong>reflect.ValueOf()</strong> gets value information</li>
                                            <li><strong>Prefer generics</strong> over reflection for performance</li>
                                            <li><strong>Use reflection</strong> when you need runtime flexibility</li>
                                        </ul>
                                    </div>

                                    <!-- What's Next -->
                                    <h2>Congratulations!</h2>
                                    <p>You've completed the advanced Go topics! You now have a comprehensive
                                        understanding of Go's
                                        modern features including generics and reflection. These tools, combined with
                                        everything
                                        you've learned, make you ready to build production-grade Go applications.</p>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="goroutines-waitgroups.jsp" />
                                    <jsp:param name="prevTitle" value="Goroutine Coordination" />
                                    <jsp:param name="nextLink" value="memory-management.jsp" />
                                    <jsp:param name="nextTitle" value="Memory Management" />
                                    <jsp:param name="currentLessonId" value="generics-reflection" />
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