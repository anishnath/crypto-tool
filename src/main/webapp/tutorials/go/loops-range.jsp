<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "loops-range" ); request.setAttribute("currentModule", "Control Flow" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Loops & Range in Go - Go Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Learn Go for loops, while-style loops, infinite loops, range keyword, and iteration. Master all loop patterns with interactive examples.">
            <meta name="keywords"
                content="go for loop, golang loops, go range, go while loop, go iteration, go break continue, go loop patterns">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Loops & Range in Go">
            <meta property="og:description" content="Master Go loops and range iteration with interactive examples.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/go/loops-range.jsp">
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
    "name": "Loops & Range in Go",
    "description": "Learn Go for loops, range keyword, and all iteration patterns with interactive examples.",
    "learningResourceType": "Tutorial",
    "educationalLevel": "Beginner",
    "interactivityType": "active",
    "inLanguage": "en",
    "isAccessibleForFree": true,
    "url": "https://8gwifi.org/tutorials/go/loops-range.jsp",
    "teaches": ["for loop", "while loop", "range", "iteration", "break", "continue"],
    "timeRequired": "PT35M"
}
            </script>

            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="loops-range">
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
                                    <span>Loops & Range</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Loops & Range</h1>
                                    <div class="lesson-meta">
                                        <span>Beginner</span>
                                        <span>~35 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">Loops allow you to execute code repeatedly. Go has only one looping
                                        construct—the
                                        <code>for</code> loop—but it's incredibly versatile. In this lesson, you'll
                                        learn all the
                                        ways to use <code>for</code> and the powerful <code>range</code> keyword for
                                        iteration.
                                    </p>

                                    <!-- Section 1: For Loop Basics -->
                                    <h2>The For Loop</h2>
                                    <p>Go has only one loop keyword: <code>for</code>. It can be used in several ways:
                                    </p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="go/for-basic.go" />
                                        <jsp:param name="language" value="go" />
                                        <jsp:param name="editorId" value="compiler-for-basic" />
                                    </jsp:include>

                                    <div class="info-box">
                                        <strong>For Loop Components:</strong>
                                        <pre><code class="language-go">for init; condition; post {
    // loop body
}</code></pre>
                                        <ul>
                                            <li><strong>init</strong>: Executed before the first iteration (optional)
                                            </li>
                                            <li><strong>condition</strong>: Evaluated before each iteration (optional)
                                            </li>
                                            <li><strong>post</strong>: Executed at the end of each iteration (optional)
                                            </li>
                                        </ul>
                                    </div>

                                    <h3>Classic For Loop</h3>
                                    <pre><code class="language-go">// Traditional C-style for loop
for i := 0; i < 5; i++ {
    fmt.Println(i)
}

// Count down
for i := 10; i > 0; i-- {
    fmt.Println(i)
}

// Step by 2
for i := 0; i < 10; i += 2 {
    fmt.Println(i)  // 0, 2, 4, 6, 8
}</code></pre>

                                    <div class="tip-box">
                                        <strong>Pro Tip:</strong> The loop variable (e.g., <code>i</code>) is scoped to
                                        the loop. It's
                                        not accessible outside the loop body.
                                    </div>

                                    <!-- Section 2: While-Style Loops -->
                                    <h2>While-Style Loops</h2>
                                    <p>Go doesn't have a <code>while</code> keyword, but you can use <code>for</code> as
                                        a while
                                        loop:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="go/for-while.go" />
                                        <jsp:param name="language" value="go" />
                                        <jsp:param name="editorId" value="compiler-while" />
                                    </jsp:include>

                                    <h3>Infinite Loops</h3>
                                    <p>Omit all components to create an infinite loop:</p>

                                    <pre><code class="language-go">// Infinite loop
for {
    fmt.Println("This runs forever!")
    // Use break to exit
    if someCondition {
        break
    }
}

// Common pattern: server loops
for {
    conn, err := listener.Accept()
    if err != nil {
        break
    }
    go handleConnection(conn)
}</code></pre>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <!-- Section 3: Range Keyword -->
                                    <h2>The Range Keyword</h2>
                                    <p>The <code>range</code> keyword iterates over elements in various data structures:
                                    </p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="go/range-slice.go" />
                                        <jsp:param name="language" value="go" />
                                        <jsp:param name="editorId" value="compiler-range-slice" />
                                    </jsp:include>

                                    <h3>Range Over Different Types</h3>
                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Type</th>
                                                <th>Syntax</th>
                                                <th>Returns</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>Slice/Array</td>
                                                <td><code>for i, v := range slice</code></td>
                                                <td>index, value</td>
                                            </tr>
                                            <tr>
                                                <td>String</td>
                                                <td><code>for i, r := range str</code></td>
                                                <td>index, rune</td>
                                            </tr>
                                            <tr>
                                                <td>Map</td>
                                                <td><code>for k, v := range map</code></td>
                                                <td>key, value</td>
                                            </tr>
                                            <tr>
                                                <td>Channel</td>
                                                <td><code>for v := range ch</code></td>
                                                <td>value</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <h3>Range Over Maps</h3>
                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="go/range-map.go" />
                                        <jsp:param name="language" value="go" />
                                        <jsp:param name="editorId" value="compiler-range-map" />
                                    </jsp:include>

                                    <div class="warning-box">
                                        <strong>Important:</strong> When ranging over a map, the iteration order is
                                        <strong>random</strong>! Don't rely on any specific order.
                                    </div>

                                    <h3>Ignoring Values with Blank Identifier</h3>
                                    <pre><code class="language-go">// Only need the index
for i := range numbers {
    fmt.Println("Index:", i)
}

// Only need the value
for _, value := range numbers {
    fmt.Println("Value:", value)
}

// Only need keys from map
for key := range myMap {
    fmt.Println("Key:", key)
}</code></pre>

                                    <!-- Section 4: Break and Continue -->
                                    <h2>Break and Continue</h2>
                                    <p>Control loop execution with <code>break</code> and <code>continue</code>:</p>

                                    <h3>Break - Exit the Loop</h3>
                                    <pre><code class="language-go">// Find first even number
for i := 1; i <= 10; i++ {
    if i%2 == 0 {
        fmt.Println("First even:", i)
        break  // Exit the loop
    }
}

// Search in slice
for _, name := range names {
    if name == "Alice" {
        fmt.Println("Found Alice!")
        break
    }
}</code></pre>

                                    <h3>Continue - Skip to Next Iteration</h3>
                                    <pre><code class="language-go">// Print only odd numbers
for i := 1; i <= 10; i++ {
    if i%2 == 0 {
        continue  // Skip even numbers
    }
    fmt.Println(i)
}

// Skip empty strings
for _, str := range strings {
    if str == "" {
        continue
    }
    fmt.Println(str)
}</code></pre>

                                    <h3>Labeled Breaks</h3>
                                    <p>Break out of nested loops using labels:</p>

                                    <pre><code class="language-go">outer:
for i := 0; i < 3; i++ {
    for j := 0; j < 3; j++ {
        if i*j > 2 {
            break outer  // Breaks out of both loops
        }
        fmt.Printf("i=%d, j=%d\n", i, j)
    }
}</code></pre>

                                    <!-- Loop Patterns -->
                                    <h2>Common Loop Patterns</h2>

                                    <h3>1. Counting</h3>
                                    <pre><code class="language-go">// Count from 1 to 10
for i := 1; i <= 10; i++ {
    fmt.Println(i)
}

// Count down
for i := 10; i >= 1; i-- {
    fmt.Println(i)
}</code></pre>

                                    <h3>2. Sum/Accumulation</h3>
                                    <pre><code class="language-go">numbers := []int{1, 2, 3, 4, 5}
sum := 0

for _, num := range numbers {
    sum += num
}
fmt.Println("Sum:", sum)  // 15</code></pre>

                                    <h3>3. Filtering</h3>
                                    <pre><code class="language-go">numbers := []int{1, 2, 3, 4, 5, 6}
var evens []int

for _, num := range numbers {
    if num%2 == 0 {
        evens = append(evens, num)
    }
}
fmt.Println(evens)  // [2, 4, 6]</code></pre>

                                    <h3>4. Finding</h3>
                                    <pre><code class="language-go">names := []string{"Alice", "Bob", "Charlie"}
found := false

for _, name := range names {
    if name == "Bob" {
        found = true
        break
    }
}
fmt.Println("Found Bob:", found)</code></pre>

                                    <!-- Common Mistakes -->
                                    <h2>Common Mistakes</h2>

                                    <div class="mistake-box">
                                        <h4>1. Modifying slice while iterating</h4>
                                        <pre><code class="language-go">// ❌ Dangerous - can cause issues
for i, v := range slice {
    slice = append(slice, v*2)  // Modifying while iterating!
}

// ✅ Correct - iterate over a copy or use index-based loop
original := make([]int, len(slice))
copy(original, slice)
for _, v := range original {
    slice = append(slice, v*2)
}</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>2. Range variable reuse</h4>
                                        <pre><code class="language-go">// ❌ Wrong - all pointers point to same variable
var ptrs []*int
for _, v := range []int{1, 2, 3} {
    ptrs = append(ptrs, &v)  // All point to same v!
}

// ✅ Correct - create new variable
var ptrs []*int
for _, v := range []int{1, 2, 3} {
    v := v  // Create new variable
    ptrs = append(ptrs, &v)
}</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>3. Infinite loop without break</h4>
                                        <pre><code class="language-go">// ❌ Wrong - runs forever
for {
    fmt.Println("Forever!")
    // No break condition!
}

// ✅ Correct - have an exit condition
count := 0
for {
    fmt.Println("Iteration:", count)
    count++
    if count >= 5 {
        break
    }
}</code></pre>
                                    </div>

                                    <!-- Exercise -->
                                    <h2>Exercise: FizzBuzz</h2>
                                    <div class="exercise-section">
                                        <p><strong>Task:</strong> Implement the classic FizzBuzz problem.</p>

                                        <p><strong>Requirements:</strong></p>
                                        <ul>
                                            <li>Loop from 1 to 30</li>
                                            <li>For multiples of 3, print "Fizz"</li>
                                            <li>For multiples of 5, print "Buzz"</li>
                                            <li>For multiples of both 3 and 5, print "FizzBuzz"</li>
                                            <li>Otherwise, print the number</li>
                                        </ul>

                                        <details class="exercise-hint">
                                            <summary>Show Solution</summary>
                                            <pre><code class="language-go">package main

import "fmt"

func main() {
    for i := 1; i <= 30; i++ {
        // Check for both 3 and 5 first
        if i%3 == 0 && i%5 == 0 {
            fmt.Println("FizzBuzz")
        } else if i%3 == 0 {
            fmt.Println("Fizz")
        } else if i%5 == 0 {
            fmt.Println("Buzz")
        } else {
            fmt.Println(i)
        }
    }
    
    // Alternative solution using string building
    fmt.Println("\n--- Alternative ---")
    for i := 1; i <= 30; i++ {
        output := ""
        if i%3 == 0 {
            output += "Fizz"
        }
        if i%5 == 0 {
            output += "Buzz"
        }
        if output == "" {
            fmt.Println(i)
        } else {
            fmt.Println(output)
        }
    }
}</code></pre>
                                        </details>
                                    </div>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>for is the only loop</strong> in Go, but it's very versatile
                                            </li>
                                            <li><strong>Classic for loop</strong>:
                                                <code>for init; condition; post</code></li>
                                            <li><strong>While-style loop</strong>: <code>for condition</code></li>
                                            <li><strong>Infinite loop</strong>: <code>for {}</code></li>
                                            <li><strong>range</strong> iterates over slices, arrays, strings, maps, and
                                                channels</li>
                                            <li><strong>range on slice/array</strong> returns index and value</li>
                                            <li><strong>range on map</strong> returns key and value (random order)</li>
                                            <li><strong>break</strong> exits the loop, <strong>continue</strong> skips
                                                to next
                                                iteration</li>
                                            <li><strong>Labeled breaks</strong> exit nested loops</li>
                                        </ul>
                                    </div>

                                    <!-- What's Next -->
                                    <h2>What's Next?</h2>
                                    <p>Congratulations on completing the Control Flow module! You can now make decisions
                                        and repeat
                                        code. Next, you'll learn about <strong>Functions & Returns</strong>, where
                                        you'll discover
                                        how to organize code into reusable blocks and work with multiple return values.
                                    </p>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="if-switch.jsp" />
                                    <jsp:param name="prevTitle" value="If & Switch" />
                                    <jsp:param name="nextLink" value="functions-returns.jsp" />
                                    <jsp:param name="nextTitle" value="Functions & Returns" />
                                    <jsp:param name="currentLessonId" value="loops-range" />
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