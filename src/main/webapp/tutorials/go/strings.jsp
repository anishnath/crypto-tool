<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "strings" ); request.setAttribute("currentModule", "Basics" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Strings in Go - Go Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Learn Go strings, UTF-8 encoding, runes, string operations, and manipulation. Master string literals, concatenation, and the strings package.">
            <meta name="keywords"
                content="go strings, golang strings, go runes, go utf-8, string operations, strings package, string manipulation, go string literals">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Strings in Go">
            <meta property="og:description" content="Master Go strings, UTF-8, runes, and string operations.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/go/strings.jsp">
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
    "name": "Strings in Go",
    "description": "Learn Go strings, UTF-8 encoding, runes, and string operations with interactive examples.",
    "learningResourceType": "Tutorial",
    "educationalLevel": "Beginner",
    "interactivityType": "active",
    "inLanguage": "en",
    "isAccessibleForFree": true,
    "url": "https://8gwifi.org/tutorials/go/strings.jsp",
    "teaches": ["Go strings", "String literals", "UTF-8", "Runes", "String operations", "strings package"],
    "timeRequired": "PT25M"
}
            </script>

            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="strings">
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
                                    <span>Strings</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Strings</h1>
                                    <div class="lesson-meta">
                                        <span>Beginner</span>
                                        <span>~25 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">Strings are sequences of characters used to represent text. In this
                                        lesson,
                                        you'll learn how Go handles strings, understand UTF-8 encoding, work with runes,
                                        and master
                                        common string operations.</p>

                                    <!-- Section 1: String Basics -->
                                    <h2>String Basics</h2>
                                    <p>In Go, strings are immutable sequences of bytes. They're typically UTF-8 encoded,
                                        which means
                                        they can represent any Unicode character:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="go/strings-basic.go" />
                                        <jsp:param name="language" value="go" />
                                        <jsp:param name="editorId" value="compiler-strings-basic" />
                                    </jsp:include>

                                    <div class="info-box">
                                        <strong>Key Points:</strong>
                                        <ul>
                                            <li>Strings are enclosed in double quotes: <code>"Hello"</code></li>
                                            <li>Raw strings use backticks: <code>`raw string`</code></li>
                                            <li>Strings are <strong>immutable</strong> - you can't change individual
                                                characters</li>
                                            <li>UTF-8 encoded by default</li>
                                        </ul>
                                    </div>

                                    <h3>String Literals</h3>
                                    <pre><code class="language-go">// Interpreted string (with escape sequences)
s1 := "Hello\nWorld"  // \n is newline

// Raw string (no escape sequences)
s2 := `Hello\nWorld`  // \n is literal text

// Multi-line raw string
s3 := `This is a
multi-line
string`</code></pre>

                                    <div class="tip-box">
                                        <strong>Pro Tip:</strong> Use raw strings (backticks) for:
                                        <ul>
                                            <li>Multi-line strings</li>
                                            <li>Regular expressions</li>
                                            <li>File paths (especially on Windows)</li>
                                            <li>JSON or HTML templates</li>
                                        </ul>
                                    </div>

                                    <!-- Section 2: String Operations -->
                                    <h2>Common String Operations</h2>
                                    <p>The <code>strings</code> package provides many useful functions for working with
                                        strings:</p>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Function</th>
                                                <th>Description</th>
                                                <th>Example</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><code>len(s)</code></td>
                                                <td>Length in bytes</td>
                                                <td><code>len("Hello")</code> → 5</td>
                                            </tr>
                                            <tr>
                                                <td><code>strings.ToUpper(s)</code></td>
                                                <td>Convert to uppercase</td>
                                                <td><code>ToUpper("hello")</code> → "HELLO"</td>
                                            </tr>
                                            <tr>
                                                <td><code>strings.ToLower(s)</code></td>
                                                <td>Convert to lowercase</td>
                                                <td><code>ToLower("HELLO")</code> → "hello"</td>
                                            </tr>
                                            <tr>
                                                <td><code>strings.Contains(s, substr)</code></td>
                                                <td>Check if contains substring</td>
                                                <td><code>Contains("Hello", "ell")</code> → true</td>
                                            </tr>
                                            <tr>
                                                <td><code>strings.Replace(s, old, new, n)</code></td>
                                                <td>Replace substring</td>
                                                <td><code>Replace("Hi Hi", "Hi", "Bye", 1)</code> → "Bye Hi"</td>
                                            </tr>
                                            <tr>
                                                <td><code>strings.Split(s, sep)</code></td>
                                                <td>Split into slice</td>
                                                <td><code>Split("a,b,c", ",")</code> → ["a", "b", "c"]</td>
                                            </tr>
                                            <tr>
                                                <td><code>strings.Join(slice, sep)</code></td>
                                                <td>Join slice into string</td>
                                                <td><code>Join(["a", "b"], ",")</code> → "a,b"</td>
                                            </tr>
                                            <tr>
                                                <td><code>strings.TrimSpace(s)</code></td>
                                                <td>Remove leading/trailing whitespace</td>
                                                <td><code>TrimSpace(" hi ")</code> → "hi"</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <h3>String Concatenation</h3>
                                    <pre><code class="language-go">// Using + operator
greeting := "Hello" + " " + "World"

// Using fmt.Sprintf
name := "Alice"
message := fmt.Sprintf("Hello, %s!", name)

// Using strings.Builder (efficient for loops)
var builder strings.Builder
builder.WriteString("Hello")
builder.WriteString(" ")
builder.WriteString("World")
result := builder.String()</code></pre>

                                    <div class="best-practice-box">
                                        <strong>Best Practice:</strong> For concatenating many strings in a loop, use
                                        <code>strings.Builder</code> instead of <code>+</code>. It's much more
                                        efficient!
                                    </div>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <!-- Section 3: Runes and UTF-8 -->
                                    <h2>Runes and UTF-8</h2>
                                    <p>Go strings are UTF-8 encoded. A <code>rune</code> represents a single Unicode
                                        code point:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="go/strings-runes.go" />
                                        <jsp:param name="language" value="go" />
                                        <jsp:param name="editorId" value="compiler-runes" />
                                    </jsp:include>

                                    <div class="info-box">
                                        <strong>Understanding Bytes vs Runes:</strong>
                                        <ul>
                                            <li><code>byte</code> - A single 8-bit value (alias for uint8)</li>
                                            <li><code>rune</code> - A Unicode code point (alias for int32)</li>
                                            <li><code>len(s)</code> - Returns byte length, not character count</li>
                                            <li>Use <code>range</code> to iterate over runes</li>
                                        </ul>
                                    </div>

                                    <h3>Why This Matters</h3>
                                    <pre><code class="language-go">s := "Hello, 世界"
fmt.Println(len(s))           // 13 bytes (not 9 characters!)

// Counting actual characters
count := 0
for range s {
    count++
}
fmt.Println(count)            // 9 characters

// Or use utf8.RuneCountInString
fmt.Println(utf8.RuneCountInString(s))  // 9</code></pre>

                                    <div class="warning-box">
                                        <strong>Common Pitfall:</strong> <code>len()</code> returns the byte length, not
                                        the
                                        character count. For non-ASCII strings, these can be different!
                                    </div>

                                    <!-- Section 4: String Indexing -->
                                    <h2>String Indexing and Slicing</h2>
                                    <pre><code class="language-go">s := "Hello"

// Indexing gives you bytes
fmt.Println(s[0])     // 72 (byte value of 'H')
fmt.Printf("%c\n", s[0])  // H (character)

// Slicing
fmt.Println(s[0:2])   // "He"
fmt.Println(s[2:])    // "llo"
fmt.Println(s[:3])    // "Hel"

// ⚠️ Be careful with multi-byte characters!
s2 := "世界"
fmt.Println(s2[0:3])  // "世" (one character, 3 bytes)</code></pre>

                                    <!-- Common Mistakes -->
                                    <h2>Common Mistakes</h2>

                                    <div class="mistake-box">
                                        <h4>1. Trying to modify strings</h4>
                                        <pre><code class="language-go">// ❌ Wrong - strings are immutable
s := "Hello"
s[0] = 'h'  // Error: cannot assign to s[0]

// ✅ Correct - create a new string
s := "Hello"
s = "h" + s[1:]  // "hello"

// Or convert to []rune, modify, convert back
runes := []rune(s)
runes[0] = 'h'
s = string(runes)</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>2. Confusing byte length with character count</h4>
                                        <pre><code class="language-go">// ❌ Wrong assumption
s := "Hello, 世界"
if len(s) == 9 {  // False! len(s) is 13
    fmt.Println("9 characters")
}

// ✅ Correct - count runes
import "unicode/utf8"

if utf8.RuneCountInString(s) == 9 {
    fmt.Println("9 characters")  // True!
}</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>3. Inefficient string concatenation in loops</h4>
                                        <pre><code class="language-go">// ❌ Inefficient - creates many temporary strings
result := ""
for i := 0; i < 1000; i++ {
    result += "x"  // Slow!
}

// ✅ Efficient - use strings.Builder
var builder strings.Builder
for i := 0; i < 1000; i++ {
    builder.WriteString("x")
}
result := builder.String()</code></pre>
                                    </div>

                                    <!-- Exercise -->
                                    <h2>Exercise: Word Counter</h2>
                                    <div class="exercise-section">
                                        <p><strong>Task:</strong> Create a program that analyzes a sentence.</p>

                                        <p><strong>Requirements:</strong></p>
                                        <ul>
                                            <li>Take a sentence: "Go is simple and powerful"</li>
                                            <li>Count the number of words</li>
                                            <li>Convert to uppercase</li>
                                            <li>Replace "simple" with "elegant"</li>
                                            <li>Print all results</li>
                                        </ul>

                                        <details class="exercise-hint">
                                            <summary>Show Solution</summary>
                                            <pre><code class="language-go">package main

import (
    "fmt"
    "strings"
)

func main() {
    sentence := "Go is simple and powerful"
    
    // Original
    fmt.Println("Original:", sentence)
    
    // Word count
    words := strings.Split(sentence, " ")
    fmt.Println("Word count:", len(words))
    
    // Uppercase
    upper := strings.ToUpper(sentence)
    fmt.Println("Uppercase:", upper)
    
    // Replace
    replaced := strings.Replace(sentence, "simple", "elegant", 1)
    fmt.Println("Replaced:", replaced)
    
    // Bonus: Check if contains
    if strings.Contains(sentence, "Go") {
        fmt.Println("Contains 'Go': true")
    }
    
    // Bonus: Character count
    fmt.Println("Character count:", len(sentence))
    fmt.Println("Rune count:", len([]rune(sentence)))
}</code></pre>
                                        </details>
                                    </div>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>Strings are immutable</strong> sequences of bytes</li>
                                            <li><strong>UTF-8 encoded</strong> by default, supporting all Unicode
                                                characters</li>
                                            <li><strong>Double quotes</strong> for interpreted strings,
                                                <strong>backticks</strong> for
                                                raw strings</li>
                                            <li><strong>rune</strong> represents a Unicode code point (int32)</li>
                                            <li><strong>len()</strong> returns byte length, not character count</li>
                                            <li><strong>strings package</strong> provides many useful functions</li>
                                            <li><strong>Use range</strong> to iterate over runes, not bytes</li>
                                            <li><strong>strings.Builder</strong> for efficient concatenation in loops
                                            </li>
                                        </ul>
                                    </div>

                                    <!-- What's Next -->
                                    <h2>What's Next?</h2>
                                    <p>Congratulations on completing the Basics module! You now understand variables,
                                        types,
                                        constants, operators, and strings. Next, you'll learn about <strong>Control
                                            Flow</strong> with
                                        if statements and switch expressions to make decisions in your programs.</p>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="constants-operators.jsp" />
                                    <jsp:param name="prevTitle" value="Constants & Operators" />
                                    <jsp:param name="nextLink" value="if-switch.jsp" />
                                    <jsp:param name="nextTitle" value="If & Switch" />
                                    <jsp:param name="currentLessonId" value="strings" />
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