<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "maps" ); request.setAttribute("currentModule", "Data Structures" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Maps in Go - Go Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Learn Go maps, hash tables, key-value pairs, map operations, and iteration. Master Go's built-in dictionary type with interactive examples.">
            <meta name="keywords"
                content="go maps, golang maps, go hash table, go dictionary, go key-value, map operations">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Maps in Go">
            <meta property="og:description" content="Master Go maps and key-value data structures.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/go/maps.jsp">
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
    "name": "Maps in Go",
    "description": "Learn Go maps, key-value pairs, and hash table operations with interactive examples.",
    "learningResourceType": "Tutorial",
    "educationalLevel": "Beginner",
    "interactivityType": "active",
    "inLanguage": "en",
    "isAccessibleForFree": true,
    "url": "https://8gwifi.org/tutorials/go/maps.jsp",
    "teaches": ["maps", "hash tables", "key-value pairs", "map operations"],
    "timeRequired": "PT35M"
}
            </script>

            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="maps">
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
                                    <span>Maps</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Maps</h1>
                                    <div class="lesson-meta">
                                        <span>Beginner</span>
                                        <span>~35 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">Maps are Go's built-in hash table type, providing fast key-value
                                        lookups. They're
                                        essential for many programming tasks, from counting occurrences to caching data.
                                        In this
                                        lesson, you'll learn how to create, use, and manipulate maps effectively.</p>

                                    <!-- Section 1: Map Basics -->
                                    <h2>What is a Map?</h2>
                                    <p>A map is an unordered collection of key-value pairs. Each key is unique and maps
                                        to a value:
                                    </p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="go/maps-basic.go" />
                                        <jsp:param name="language" value="go" />
                                        <jsp:param name="editorId" value="compiler-maps-basic" />
                                    </jsp:include>

                                    <div class="info-box">
                                        <strong>Map Characteristics:</strong>
                                        <ul>
                                            <li><strong>Unordered</strong> - Iteration order is random</li>
                                            <li><strong>Reference type</strong> - Like slices, maps are references</li>
                                            <li><strong>Dynamic</strong> - Can grow as needed</li>
                                            <li><strong>Fast lookups</strong> - O(1) average time complexity</li>
                                        </ul>
                                    </div>

                                    <h3>Creating Maps</h3>
                                    <pre><code class="language-go">// Map literal
ages := map[string]int{
    "Alice": 25,
    "Bob":   30,
    "Carol": 28,
}

// Using make
scores := make(map[string]int)

// Empty map literal
empty := map[string]int{}

// Nil map (can't add to it!)
var nilMap map[string]int  // nil</code></pre>

                                    <div class="warning-box">
                                        <strong>Important:</strong> A nil map can be read from but not written to.
                                        Always initialize
                                        maps with <code>make()</code> or a map literal before adding elements!
                                    </div>

                                    <!-- Section 2: Map Operations -->
                                    <h2>Map Operations</h2>

                                    <h3>Adding and Updating</h3>
                                    <pre><code class="language-go">ages := make(map[string]int)

// Add new key-value pair
ages["Alice"] = 25

// Update existing value
ages["Alice"] = 26

// Add multiple
ages["Bob"] = 30
ages["Carol"] = 28</code></pre>

                                    <h3>Retrieving Values</h3>
                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="go/maps-operations.go" />
                                        <jsp:param name="language" value="go" />
                                        <jsp:param name="editorId" value="compiler-maps-retrieve" />
                                    </jsp:include>

                                    <div class="info-box">
                                        <strong>The "comma ok" Idiom:</strong>
                                        <pre><code class="language-go">value, ok := myMap[key]
if ok {
    // Key exists, use value
} else {
    // Key doesn't exist
}</code></pre>
                                        This is the idiomatic way to check if a key exists in Go!
                                    </div>

                                    <h3>Deleting Keys</h3>
                                    <pre><code class="language-go">ages := map[string]int{
    "Alice": 25,
    "Bob":   30,
}

// Delete a key
delete(ages, "Alice")

// Delete non-existent key (safe, no error)
delete(ages, "NonExistent")

fmt.Println(ages)  // map[Bob:30]</code></pre>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <!-- Section 3: Iterating Over Maps -->
                                    <h2>Iterating Over Maps</h2>
                                    <p>Use <code>range</code> to iterate over maps:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="go/maps-operations.go" />
                                        <jsp:param name="language" value="go" />
                                        <jsp:param name="editorId" value="compiler-maps-iter" />
                                    </jsp:include>

                                    <div class="warning-box">
                                        <strong>Remember:</strong> Map iteration order is <strong>random</strong>! Don't
                                        rely on any
                                        specific order. If you need ordered keys, sort them first.
                                    </div>

                                    <h3>Sorting Map Keys</h3>
                                    <pre><code class="language-go">import "sort"

ages := map[string]int{
    "Carol": 28,
    "Alice": 25,
    "Bob":   30,
}

// Get keys
keys := make([]string, 0, len(ages))
for k := range ages {
    keys = append(keys, k)
}

// Sort keys
sort.Strings(keys)

// Iterate in sorted order
for _, k := range keys {
    fmt.Printf("%s: %d\n", k, ages[k])
}
// Output:
// Alice: 25
// Bob: 30
// Carol: 28</code></pre>

                                    <!-- Section 4: Map as a Set -->
                                    <h2>Using Maps as Sets</h2>
                                    <p>Go doesn't have a built-in set type, but maps can be used as sets:</p>

                                    <pre><code class="language-go">// Set of strings
set := make(map[string]bool)

// Add elements
set["apple"] = true
set["banana"] = true
set["orange"] = true

// Check membership
if set["apple"] {
    fmt.Println("apple is in the set")
}

// Remove element
delete(set, "banana")

// Iterate over set
for item := range set {
    fmt.Println(item)
}

// Alternative: use empty struct (saves memory)
set2 := make(map[string]struct{})
set2["apple"] = struct{}{}
_, exists := set2["apple"]  // true</code></pre>

                                    <div class="tip-box">
                                        <strong>Pro Tip:</strong> Use <code>map[string]struct{}{}</code> for sets
                                        instead of
                                        <code>map[string]bool</code> to save memory. Empty structs take zero bytes!
                                    </div>

                                    <div class="diagram-container">
                                        <img src="<%=request.getContextPath()%>/tutorials/assets/images/go-maps-structure.svg"
                                            alt="Go Maps Structure - Hash Table with Buckets" class="tutorial-diagram"
                                            style="max-width: 100%; height: auto; margin: 2rem 0;" />
                                        <p class="diagram-caption">Figure: Go Maps - Hash table structure with buckets
                                            and common operations</p>
                                    </div>

                                    <!-- Section 5: Practical Patterns -->
                                    <h2>Practical Map Patterns</h2>

                                    <h3>1. Counting Occurrences</h3>
                                    <pre><code class="language-go">words := []string{"apple", "banana", "apple", "orange", "banana", "apple"}

counts := make(map[string]int)
for _, word := range words {
    counts[word]++  // Zero value is 0, so this works!
}

fmt.Println(counts)  // map[apple:3 banana:2 orange:1]</code></pre>

                                    <h3>2. Grouping Data</h3>
                                    <pre><code class="language-go">type Person struct {
    Name string
    Age  int
}

people := []Person{
    {"Alice", 25},
    {"Bob", 30},
    {"Carol", 25},
    {"Dave", 30},
}

// Group by age
byAge := make(map[int][]Person)
for _, p := range people {
    byAge[p.Age] = append(byAge[p.Age], p)
}

// byAge[25] = [Alice, Carol]
// byAge[30] = [Bob, Dave]</code></pre>

                                    <h3>3. Caching/Memoization</h3>
                                    <pre><code class="language-go">var cache = make(map[int]int)

func fibonacci(n int) int {
    // Check cache
    if val, ok := cache[n]; ok {
        return val
    }
    
    // Calculate
    var result int
    if n <= 1 {
        result = n
    } else {
        result = fibonacci(n-1) + fibonacci(n-2)
    }
    
    // Store in cache
    cache[n] = result
    return result
}</code></pre>

                                    <!-- Common Mistakes -->
                                    <h2>Common Mistakes</h2>

                                    <div class="mistake-box">
                                        <h4>1. Writing to nil map</h4>
                                        <pre><code class="language-go">// ❌ Wrong - panic: assignment to entry in nil map
var ages map[string]int
ages["Alice"] = 25  // Runtime panic!

// ✅ Correct - initialize first
ages := make(map[string]int)
ages["Alice"] = 25

// Or use map literal
ages := map[string]int{}
ages["Alice"] = 25</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>2. Not checking if key exists</h4>
                                        <pre><code class="language-go">// ❌ Wrong - can't distinguish between zero value and missing key
ages := map[string]int{"Alice": 0}
age := ages["Bob"]  // 0 (zero value)
// Is Bob's age 0, or does the key not exist?

// ✅ Correct - use comma ok idiom
if age, ok := ages["Bob"]; ok {
    fmt.Println("Bob's age:", age)
} else {
    fmt.Println("Bob not found")
}</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>3. Relying on iteration order</h4>
                                        <pre><code class="language-go">// ❌ Wrong - order is random!
ages := map[string]int{
    "Alice": 25,
    "Bob":   30,
    "Carol": 28,
}
for name := range ages {
    fmt.Println(name)  // Random order each time!
}

// ✅ Correct - sort keys if order matters
keys := make([]string, 0, len(ages))
for k := range ages {
    keys = append(keys, k)
}
sort.Strings(keys)
for _, k := range keys {
    fmt.Println(k, ages[k])
}</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>4. Concurrent map access</h4>
                                        <pre><code class="language-go">// ❌ Wrong - concurrent map writes cause panic
m := make(map[int]int)
go func() { m[1] = 1 }()
go func() { m[2] = 2 }()  // Race condition!

// ✅ Correct - use sync.Mutex or sync.Map
var mu sync.Mutex
m := make(map[int]int)

go func() {
    mu.Lock()
    m[1] = 1
    mu.Unlock()
}()</code></pre>
                                    </div>

                                    <!-- Exercise -->
                                    <h2>Exercise: Word Frequency Counter</h2>
                                    <div class="exercise-section">
                                        <p><strong>Task:</strong> Create a word frequency counter.</p>

                                        <p><strong>Requirements:</strong></p>
                                        <ul>
                                            <li>Count word frequencies in a sentence</li>
                                            <li>Find the most common word</li>
                                            <li>Print words in alphabetical order with counts</li>
                                            <li>Test with: "the quick brown fox jumps over the lazy dog the fox"</li>
                                        </ul>

                                        <details class="exercise-hint">
                                            <summary>Show Solution</summary>
                                            <pre><code class="language-go">package main

import (
    "fmt"
    "sort"
    "strings"
)

func main() {
    text := "the quick brown fox jumps over the lazy dog the fox"
    
    // Split into words
    words := strings.Fields(text)
    
    // Count frequencies
    freq := make(map[string]int)
    for _, word := range words {
        freq[word]++
    }
    
    // Find most common word
    maxCount := 0
    mostCommon := ""
    for word, count := range freq {
        if count > maxCount {
            maxCount = count
            mostCommon = word
        }
    }
    
    fmt.Printf("Most common word: '%s' (appears %d times)\n\n", mostCommon, maxCount)
    
    // Get sorted keys
    keys := make([]string, 0, len(freq))
    for k := range freq {
        keys = append(keys, k)
    }
    sort.Strings(keys)
    
    // Print in alphabetical order
    fmt.Println("Word frequencies (alphabetical):")
    for _, word := range keys {
        fmt.Printf("  %s: %d\n", word, freq[word])
    }
    
    // Bonus: Total unique words
    fmt.Printf("\nTotal unique words: %d\n", len(freq))
    fmt.Printf("Total words: %d\n", len(words))
}</code></pre>
                                        </details>
                                    </div>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>Maps</strong> store key-value pairs with fast lookups</li>
                                            <li><strong>Create maps</strong> with make() or map literals</li>
                                            <li><strong>Nil maps</strong> can be read but not written to</li>
                                            <li><strong>Comma ok idiom</strong> checks if a key exists</li>
                                            <li><strong>delete()</strong> removes keys from maps</li>
                                            <li><strong>Iteration order is random</strong> - sort keys if needed</li>
                                            <li><strong>Maps are reference types</strong> - passed by reference</li>
                                            <li><strong>Not safe for concurrent use</strong> - use mutex or sync.Map
                                            </li>
                                        </ul>
                                    </div>

                                    <!-- What's Next -->
                                    <h2>What's Next?</h2>
                                    <p>Now that you understand maps, you're ready to learn about <strong>Structs &
                                            Methods</strong>.
                                        Structs let you create custom types, and methods let you add behavior to those
                                        types—the
                                        foundation of object-oriented programming in Go!</p>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="arrays-slices.jsp" />
                                    <jsp:param name="prevTitle" value="Arrays & Slices" />
                                    <jsp:param name="nextLink" value="structs-methods.jsp" />
                                    <jsp:param name="nextTitle" value="Structs & Methods" />
                                    <jsp:param name="currentLessonId" value="maps" />
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