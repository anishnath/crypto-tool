<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "arrays-slices" ); request.setAttribute("currentModule", "Data Structures"
        ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Arrays & Slices in Go - Go Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Learn Go arrays and slices, dynamic arrays, append, copy, and slice operations. Master Go's most important collection type with interactive examples.">
            <meta name="keywords"
                content="go arrays, golang slices, go slice operations, go append, go dynamic arrays, go collections">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Arrays & Slices in Go">
            <meta property="og:description" content="Master Go arrays and slices with interactive examples.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/go/arrays-slices.jsp">
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
    "name": "Arrays & Slices in Go",
    "description": "Learn Go arrays and slices, the most important collection types in Go.",
    "learningResourceType": "Tutorial",
    "educationalLevel": "Beginner",
    "interactivityType": "active",
    "inLanguage": "en",
    "isAccessibleForFree": true,
    "url": "https://8gwifi.org/tutorials/go/arrays-slices.jsp",
    "teaches": ["arrays", "slices", "append", "copy", "slice operations"],
    "timeRequired": "PT40M"
}
            </script>

            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="arrays-slices">
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
                                    <span>Arrays & Slices</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Arrays & Slices</h1>
                                    <div class="lesson-meta">
                                        <span>Beginner</span>
                                        <span>~40 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">Arrays and slices are fundamental data structures in Go. While
                                        arrays have a
                                        fixed size, slices are dynamic and flexible—making them the most commonly used
                                        collection
                                        type. In this lesson, you'll master both and learn when to use each.</p>

                                    <!-- Section 1: Arrays -->
                                    <h2>Arrays</h2>
                                    <p>An array is a fixed-size sequence of elements of the same type:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="go/arrays-basic.go" />
                                        <jsp:param name="language" value="go" />
                                        <jsp:param name="editorId" value="compiler-arrays" />
                                    </jsp:include>

                                    <div class="info-box">
                                        <strong>Array Characteristics:</strong>
                                        <ul>
                                            <li><strong>Fixed size</strong> - Size is part of the type</li>
                                            <li><strong>Value type</strong> - Copying creates a new array</li>
                                            <li><strong>Zero-indexed</strong> - First element is at index 0</li>
                                            <li><strong>Initialized to zero values</strong> by default</li>
                                        </ul>
                                    </div>

                                    <h3>Array Declaration</h3>
                                    <pre><code class="language-go">// Declare with size
var arr [5]int  // [0 0 0 0 0]

// Declare and initialize
numbers := [5]int{1, 2, 3, 4, 5}

// Let compiler count the size
numbers := [...]int{1, 2, 3, 4, 5}  // Size is 5

// Initialize specific indices
arr := [5]int{0: 10, 2: 20, 4: 30}  // [10 0 20 0 30]</code></pre>

                                    <div class="warning-box">
                                        <strong>Important:</strong> Arrays with different sizes are different types!
                                        <code>[3]int</code> and <code>[5]int</code> are completely different types.
                                    </div>

                                    <!-- Section 2: Slices -->
                                    <h2>Slices</h2>
                                    <p>Slices are dynamic, flexible views into arrays. They're the most common way to
                                        work with
                                        sequences in Go:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="go/slices-basic.go" />
                                        <jsp:param name="language" value="go" />
                                        <jsp:param name="editorId" value="compiler-slices" />
                                    </jsp:include>

                                    <div class="info-box">
                                        <strong>Slice Characteristics:</strong>
                                        <ul>
                                            <li><strong>Dynamic size</strong> - Can grow and shrink</li>
                                            <li><strong>Reference type</strong> - Points to underlying array</li>
                                            <li><strong>Three components</strong> - Pointer, length, capacity</li>
                                            <li><strong>Most commonly used</strong> collection in Go</li>
                                        </ul>
                                    </div>

                                    <h3>Creating Slices</h3>
                                    <pre><code class="language-go">// Slice literal
numbers := []int{1, 2, 3, 4, 5}

// Using make (length and capacity)
slice := make([]int, 5)      // length 5, capacity 5
slice := make([]int, 5, 10)  // length 5, capacity 10

// From an array
arr := [5]int{1, 2, 3, 4, 5}
slice := arr[1:4]  // [2 3 4]

// Empty slice
var slice []int  // nil slice</code></pre>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <!-- Section 3: Length and Capacity -->
                                    <h2>Length and Capacity</h2>
                                    <p>Slices have both length and capacity:</p>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Property</th>
                                                <th>Function</th>
                                                <th>Description</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><strong>Length</strong></td>
                                                <td><code>len(slice)</code></td>
                                                <td>Number of elements in the slice</td>
                                            </tr>
                                            <tr>
                                                <td><strong>Capacity</strong></td>
                                                <td><code>cap(slice)</code></td>
                                                <td>Number of elements in underlying array (from first element)</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <pre><code class="language-go">slice := make([]int, 5, 10)
fmt.Println(len(slice))  // 5 (length)
fmt.Println(cap(slice))  // 10 (capacity)

// Slicing affects length but not capacity
s := []int{1, 2, 3, 4, 5}
s2 := s[1:3]  // [2 3]
fmt.Println(len(s2))  // 2
fmt.Println(cap(s2))  // 4 (from index 1 to end of array)</code></pre>

                                    <!-- Section 4: Append -->
                                    <h2>Appending to Slices</h2>
                                    <p>The <code>append</code> function adds elements to a slice:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="go/slices-append.go" />
                                        <jsp:param name="language" value="go" />
                                        <jsp:param name="editorId" value="compiler-append" />
                                    </jsp:include>

                                    <div class="info-box">
                                        <strong>How Append Works:</strong>
                                        <ol>
                                            <li>If capacity is sufficient, append adds to existing array</li>
                                            <li>If capacity is exceeded, a new larger array is allocated</li>
                                            <li>Elements are copied to the new array</li>
                                            <li>The slice is updated to point to the new array</li>
                                        </ol>
                                    </div>

                                    <h3>Append Patterns</h3>
                                    <pre><code class="language-go">// Append single element
slice = append(slice, 6)

// Append multiple elements
slice = append(slice, 7, 8, 9)

// Append another slice (use ...)
slice1 := []int{1, 2, 3}
slice2 := []int{4, 5, 6}
slice1 = append(slice1, slice2...)  // [1 2 3 4 5 6]</code></pre>

                                    <div class="best-practice-box">
                                        <strong>Best Practice:</strong> Always assign the result of append back to the
                                        slice:
                                        <code>slice = append(slice, value)</code>. The underlying array may change!
                                    </div>

                                    <!-- Section 5: Slice Operations -->
                                    <h2>Slice Operations</h2>

                                    <h3>Slicing Syntax</h3>
                                    <pre><code class="language-go">s := []int{0, 1, 2, 3, 4, 5}

s[1:4]   // [1 2 3] - from index 1 to 3
s[:3]    // [0 1 2] - from start to index 2
s[3:]    // [3 4 5] - from index 3 to end
s[:]     // [0 1 2 3 4 5] - entire slice

// With capacity
s[1:3:5]  // [1 2] with capacity 4</code></pre>

                                    <h3>Copy Function</h3>
                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="go/slices-operations.go" />
                                        <jsp:param name="language" value="go" />
                                        <jsp:param name="editorId" value="compiler-copy" />
                                    </jsp:include>

                                    <div class="tip-box">
                                        <strong>Pro Tip:</strong> <code>copy</code> returns the number of elements
                                        copied, which is
                                        the minimum of <code>len(dst)</code> and <code>len(src)</code>.
                                    </div>

                                    <!-- Section 6: Arrays vs Slices -->
                                    <h2>Arrays vs Slices: When to Use Which?</h2>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Feature</th>
                                                <th>Array</th>
                                                <th>Slice</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><strong>Size</strong></td>
                                                <td>Fixed</td>
                                                <td>Dynamic</td>
                                            </tr>
                                            <tr>
                                                <td><strong>Type</strong></td>
                                                <td>Value type</td>
                                                <td>Reference type</td>
                                            </tr>
                                            <tr>
                                                <td><strong>Passing to functions</strong></td>
                                                <td>Copies entire array</td>
                                                <td>Copies slice header (cheap)</td>
                                            </tr>
                                            <tr>
                                                <td><strong>Common usage</strong></td>
                                                <td>Rare (fixed-size data)</td>
                                                <td>Very common</td>
                                            </tr>
                                            <tr>
                                                <td><strong>Can grow?</strong></td>
                                                <td>No</td>
                                                <td>Yes (with append)</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <div class="best-practice-box">
                                        <strong>Best Practice:</strong> Use slices in almost all cases. Arrays are
                                        mainly used when
                                        you need a fixed size or for performance-critical code where you want to avoid
                                        heap
                                        allocations.
                                    </div>

                                    <div class="diagram-container">
                                        <img src="<%=request.getContextPath()%>/tutorials/assets/images/go-arrays-slices-diagram.svg"
                                            alt="Arrays vs Slices in Go - Visual Comparison" class="tutorial-diagram"
                                            style="max-width: 100%; height: auto; margin: 2rem 0;" />
                                        <p class="diagram-caption">Figure: Arrays vs Slices - Understanding fixed-size
                                            arrays and dynamic slices with their internal structure</p>
                                    </div>

                                    <!-- Common Mistakes -->
                                    <h2>Common Mistakes</h2>

                                    <div class="mistake-box">
                                        <h4>1. Not assigning append result</h4>
                                        <pre><code class="language-go">// ❌ Wrong - append result not assigned
slice := []int{1, 2, 3}
append(slice, 4)  // Doesn't modify slice!
fmt.Println(slice)  // [1 2 3]

// ✅ Correct
slice = append(slice, 4)
fmt.Println(slice)  // [1 2 3 4]</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>2. Slice sharing underlying array</h4>
                                        <pre><code class="language-go">// ❌ Unexpected - slices share array
original := []int{1, 2, 3, 4, 5}
slice1 := original[0:3]
slice2 := original[2:5]
slice1[2] = 99
fmt.Println(slice2)  // [99 4 5] - affected!

// ✅ Correct - use copy for independence
original := []int{1, 2, 3, 4, 5}
slice1 := make([]int, 3)
copy(slice1, original[0:3])
slice1[2] = 99
fmt.Println(original)  // [1 2 3 4 5] - unchanged</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>3. Comparing slices with ==</h4>
                                        <pre><code class="language-go">// ❌ Wrong - can't compare slices
s1 := []int{1, 2, 3}
s2 := []int{1, 2, 3}
if s1 == s2 {  // Error: invalid operation
    // ...
}

// ✅ Correct - compare manually or use reflect.DeepEqual
func equal(a, b []int) bool {
    if len(a) != len(b) {
        return false
    }
    for i := range a {
        if a[i] != b[i] {
            return false
        }
    }
    return true
}</code></pre>
                                    </div>

                                    <!-- Exercise -->
                                    <h2>Exercise: Slice Manipulation</h2>
                                    <div class="exercise-section">
                                        <p><strong>Task:</strong> Create functions to manipulate slices.</p>

                                        <p><strong>Requirements:</strong></p>
                                        <ul>
                                            <li>Create a function <code>filter</code> that removes even numbers</li>
                                            <li>Create a function <code>reverse</code> that reverses a slice</li>
                                            <li>Test with slice: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]</li>
                                            <li>Print original, filtered, and reversed</li>
                                        </ul>

                                        <details class="exercise-hint">
                                            <summary>Show Solution</summary>
                                            <pre><code class="language-go">package main

import "fmt"

// filter removes even numbers from slice
func filter(numbers []int) []int {
    result := []int{}
    for _, num := range numbers {
        if num%2 != 0 {  // Keep odd numbers
            result = append(result, num)
        }
    }
    return result
}

// reverse reverses a slice
func reverse(numbers []int) []int {
    result := make([]int, len(numbers))
    for i, num := range numbers {
        result[len(numbers)-1-i] = num
    }
    return result
}

// reverseInPlace reverses a slice in place
func reverseInPlace(numbers []int) {
    for i := 0; i < len(numbers)/2; i++ {
        j := len(numbers) - 1 - i
        numbers[i], numbers[j] = numbers[j], numbers[i]
    }
}

func main() {
    original := []int{1, 2, 3, 4, 5, 6, 7, 8, 9, 10}
    
    fmt.Println("Original:", original)
    
    // Filter even numbers
    filtered := filter(original)
    fmt.Println("Filtered (odd only):", filtered)
    
    // Reverse
    reversed := reverse(original)
    fmt.Println("Reversed:", reversed)
    
    // Bonus: Reverse in place
    nums := []int{1, 2, 3, 4, 5}
    reverseInPlace(nums)
    fmt.Println("Reversed in place:", nums)
}</code></pre>
                                        </details>
                                    </div>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>Arrays</strong> have fixed size and are value types</li>
                                            <li><strong>Slices</strong> are dynamic and reference underlying arrays</li>
                                            <li><strong>Slices have length and capacity</strong> - use len() and cap()
                                            </li>
                                            <li><strong>append</strong> adds elements, may allocate new array</li>
                                            <li><strong>copy</strong> copies elements between slices</li>
                                            <li><strong>Slicing syntax</strong>: s[low:high] or s[low:high:max]</li>
                                            <li><strong>Always assign append result</strong> back to the slice</li>
                                            <li><strong>Use slices</strong> for almost everything (not arrays)</li>
                                        </ul>
                                    </div>

                                    <!-- What's Next -->
                                    <h2>What's Next?</h2>
                                    <p>Now that you understand slices, you're ready to learn about
                                        <strong>Maps</strong>—Go's
                                        built-in hash table type for key-value pairs. Maps are essential for many
                                        programming tasks!
                                    </p>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="panic-recover.jsp" />
                                    <jsp:param name="prevTitle" value="Panic & Recover" />
                                    <jsp:param name="nextLink" value="maps.jsp" />
                                    <jsp:param name="nextTitle" value="Maps" />
                                    <jsp:param name="currentLessonId" value="arrays-slices" />
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