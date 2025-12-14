<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "if-switch" ); request.setAttribute("currentModule", "Control Flow" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>If & Switch Statements in Go - Go Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Learn Go if statements, else if, switch expressions, type switches, and control flow. Master conditional logic with interactive examples.">
            <meta name="keywords"
                content="go if statement, golang if, go switch, go else if, go type switch, go control flow, go conditionals">

            <meta property="og:type" content="article">
            <meta property="og:title" content="If & Switch Statements in Go">
            <meta property="og:description" content="Master Go conditional statements with if, else, and switch.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/go/if-switch.jsp">
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
    "name": "If & Switch Statements in Go",
    "description": "Learn Go if statements, else if, switch expressions, and type switches with interactive examples.",
    "learningResourceType": "Tutorial",
    "educationalLevel": "Beginner",
    "interactivityType": "active",
    "inLanguage": "en",
    "isAccessibleForFree": true,
    "url": "https://8gwifi.org/tutorials/go/if-switch.jsp",
    "teaches": ["if statements", "else if", "switch", "type switch", "control flow"],
    "timeRequired": "PT35M"
}
            </script>

            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="if-switch">
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
                                    <span>If & Switch</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">If & Switch Statements</h1>
                                    <div class="lesson-meta">
                                        <span>Beginner</span>
                                        <span>~35 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">Control flow statements let your program make decisions. In this
                                        lesson, you'll
                                        learn how to use if statements for simple conditions and switch statements for
                                        multiple
                                        choices, making your Go programs dynamic and responsive.</p>

                                    <!-- Section 1: If Statements -->
                                    <h2>If Statements</h2>
                                    <p>The <code>if</code> statement executes code when a condition is true. Unlike many
                                        languages,
                                        Go doesn't require parentheses around the condition:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="go/if-basic.go" />
                                        <jsp:param name="language" value="go" />
                                        <jsp:param name="editorId" value="compiler-if-basic" />
                                    </jsp:include>

                                    <div class="info-box">
                                        <strong>Key Points:</strong>
                                        <ul>
                                            <li>No parentheses needed around the condition</li>
                                            <li>Braces <code>{}</code> are <strong>required</strong>, even for single
                                                statements</li>
                                            <li>Opening brace must be on the same line as <code>if</code></li>
                                            <li>Conditions must be boolean expressions</li>
                                        </ul>
                                    </div>

                                    <h3>If-Else and Else If</h3>
                                    <pre><code class="language-go">// If-else
if age >= 18 {
    fmt.Println("Adult")
} else {
    fmt.Println("Minor")
}

// Else if chain
if score >= 90 {
    fmt.Println("Grade: A")
} else if score >= 80 {
    fmt.Println("Grade: B")
} else if score >= 70 {
    fmt.Println("Grade: C")
} else {
    fmt.Println("Grade: F")
}</code></pre>

                                    <div class="warning-box">
                                        <strong>Important:</strong> In Go, you can't write <code>if (x > 5)</code> with
                                        parentheses
                                        around the condition. Also, the condition must be a boolean—no truthy/falsy
                                        values like in
                                        JavaScript or Python!
                                    </div>

                                    <!-- Section 2: If with Short Statement -->
                                    <h2>If with Short Statement</h2>
                                    <p>Go allows you to execute a short statement before the condition. This is useful
                                        for limiting
                                        variable scope:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="go/if-short.go" />
                                        <jsp:param name="language" value="go" />
                                        <jsp:param name="editorId" value="compiler-if-short" />
                                    </jsp:include>

                                    <div class="best-practice-box">
                                        <strong>Best Practice:</strong> Use short statements to limit variable scope.
                                        The variable
                                        declared in the short statement is only available within the if-else block.
                                    </div>

                                    <h3>Common Pattern: Error Checking</h3>
                                    <pre><code class="language-go">// Common Go pattern
if err := doSomething(); err != nil {
    fmt.Println("Error:", err)
    return
}

// err is not accessible here

// Another example
if value, ok := myMap["key"]; ok {
    fmt.Println("Found:", value)
} else {
    fmt.Println("Not found")
}</code></pre>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <!-- Section 3: Switch Statements -->
                                    <h2>Switch Statements</h2>
                                    <p>Switch statements provide a cleaner way to write multiple if-else conditions:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="go/switch-basic.go" />
                                        <jsp:param name="language" value="go" />
                                        <jsp:param name="editorId" value="compiler-switch" />
                                    </jsp:include>

                                    <div class="info-box">
                                        <strong>Go Switch Features:</strong>
                                        <ul>
                                            <li>No <code>break</code> needed—cases don't fall through by default</li>
                                            <li>Can have multiple values in a case</li>
                                            <li>Cases can be expressions, not just constants</li>
                                            <li>Can switch without a condition (like if-else chain)</li>
                                        </ul>
                                    </div>

                                    <h3>Switch Without Condition</h3>
                                    <p>A switch without a condition is the same as <code>switch true</code>, making it a
                                        cleaner
                                        if-else chain:</p>

                                    <pre><code class="language-go">hour := time.Now().Hour()

switch {
case hour < 12:
    fmt.Println("Good morning!")
case hour < 18:
    fmt.Println("Good afternoon!")
default:
    fmt.Println("Good evening!")
}</code></pre>

                                    <h3>Multiple Values in Case</h3>
                                    <pre><code class="language-go">day := "Saturday"

switch day {
case "Saturday", "Sunday":
    fmt.Println("It's the weekend!")
case "Monday":
    fmt.Println("Start of the week")
default:
    fmt.Println("It's a weekday")
}</code></pre>

                                    <h3>Fallthrough</h3>
                                    <p>If you need C-style fallthrough behavior, use the <code>fallthrough</code>
                                        keyword:</p>

                                    <pre><code class="language-go">switch num := 2; num {
case 1:
    fmt.Println("One")
case 2:
    fmt.Println("Two")
    fallthrough  // Continues to next case
case 3:
    fmt.Println("Three")
}
// Output: Two
//         Three</code></pre>

                                    <div class="tip-box">
                                        <strong>Pro Tip:</strong> <code>fallthrough</code> is rarely needed in Go. The
                                        default
                                        non-fallthrough behavior is usually what you want!
                                    </div>

                                    <!-- Section 4: Type Switch -->
                                    <h2>Type Switch</h2>
                                    <p>Type switches allow you to compare types instead of values. This is useful when
                                        working with
                                        interfaces:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="go/switch-type.go" />
                                        <jsp:param name="language" value="go" />
                                        <jsp:param name="editorId" value="compiler-type-switch" />
                                    </jsp:include>

                                    <div class="info-box">
                                        <strong>Type Switch Syntax:</strong>
                                        <pre><code class="language-go">switch v := i.(type) {
case int:
    // v is an int
case string:
    // v is a string
default:
    // v has the same type as i
}</code></pre>
                                    </div>

                                    <!-- Comparison Table -->
                                    <h2>If vs Switch: When to Use Which?</h2>
                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Use If When...</th>
                                                <th>Use Switch When...</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>Simple true/false condition</td>
                                                <td>Multiple specific values to check</td>
                                            </tr>
                                            <tr>
                                                <td>Range comparisons (&lt;, &gt;, etc.)</td>
                                                <td>Equality checks against constants</td>
                                            </tr>
                                            <tr>
                                                <td>Complex boolean logic</td>
                                                <td>Type checking (type switch)</td>
                                            </tr>
                                            <tr>
                                                <td>2-3 conditions max</td>
                                                <td>4+ conditions</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <!-- Common Mistakes -->
                                    <h2>Common Mistakes</h2>

                                    <div class="mistake-box">
                                        <h4>1. Using non-boolean conditions</h4>
                                        <pre><code class="language-go">// ❌ Wrong - won't compile
x := 5
if x {  // Error: non-bool used as if condition
    fmt.Println("x is truthy")
}

// ✅ Correct - explicit comparison
if x != 0 {
    fmt.Println("x is not zero")
}</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>2. Missing braces</h4>
                                        <pre><code class="language-go">// ❌ Wrong - syntax error
if x > 5
    fmt.Println("Greater")

// ✅ Correct - braces required
if x > 5 {
    fmt.Println("Greater")
}</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>3. Expecting switch fallthrough</h4>
                                        <pre><code class="language-go">// ❌ Wrong expectation (from C/Java)
switch x {
case 1:
    fmt.Println("One")
case 2:
    fmt.Println("Two")
}
// Only prints "One" if x is 1, not "One" and "Two"

// ✅ Correct - Go doesn't fall through by default
// This is actually the desired behavior!</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>4. Opening brace on wrong line</h4>
                                        <pre><code class="language-go">// ❌ Wrong - syntax error
if x > 5
{
    fmt.Println("Greater")
}

// ✅ Correct - brace on same line
if x > 5 {
    fmt.Println("Greater")
}</code></pre>
                                    </div>

                                    <!-- Exercise -->
                                    <h2>Exercise: Grade Calculator</h2>
                                    <div class="exercise-section">
                                        <p><strong>Task:</strong> Create a program that determines letter grades and
                                            provides
                                            feedback.</p>

                                        <p><strong>Requirements:</strong></p>
                                        <ul>
                                            <li>Take a score variable (use 85)</li>
                                            <li>Use if-else to determine the letter grade:
                                                <ul>
                                                    <li>90-100: A</li>
                                                    <li>80-89: B</li>
                                                    <li>70-79: C</li>
                                                    <li>60-69: D</li>
                                                    <li>Below 60: F</li>
                                                </ul>
                                            </li>
                                            <li>Use switch to provide feedback based on grade</li>
                                            <li>Print both grade and feedback</li>
                                        </ul>

                                        <details class="exercise-hint">
                                            <summary>Show Solution</summary>
                                            <pre><code class="language-go">package main

import "fmt"

func main() {
    score := 85
    var grade string
    
    // Determine letter grade
    if score >= 90 {
        grade = "A"
    } else if score >= 80 {
        grade = "B"
    } else if score >= 70 {
        grade = "C"
    } else if score >= 60 {
        grade = "D"
    } else {
        grade = "F"
    }
    
    fmt.Printf("Score: %d, Grade: %s\n", score, grade)
    
    // Provide feedback based on grade
    switch grade {
    case "A":
        fmt.Println("Excellent work!")
    case "B":
        fmt.Println("Good job!")
    case "C":
        fmt.Println("Satisfactory")
    case "D":
        fmt.Println("Needs improvement")
    case "F":
        fmt.Println("Please see instructor")
    }
    
    // Bonus: Check if passing
    switch {
    case score >= 60:
        fmt.Println("Status: Passing")
    default:
        fmt.Println("Status: Failing")
    }
}</code></pre>
                                        </details>
                                    </div>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>if statements</strong> execute code when conditions are true
                                            </li>
                                            <li><strong>No parentheses</strong> needed around conditions in Go</li>
                                            <li><strong>Braces required</strong> even for single statements</li>
                                            <li><strong>Short statements</strong> in if limit variable scope</li>
                                            <li><strong>switch statements</strong> provide cleaner multi-way branches
                                            </li>
                                            <li><strong>No break needed</strong> in switch—cases don't fall through</li>
                                            <li><strong>Multiple values</strong> allowed in switch cases</li>
                                            <li><strong>Switch without condition</strong> acts like if-else chain</li>
                                            <li><strong>Type switch</strong> compares types instead of values</li>
                                        </ul>
                                    </div>

                                    <!-- What's Next -->
                                    <h2>What's Next?</h2>
                                    <p>Now that you can make decisions in your code, it's time to learn about
                                        <strong>Loops &
                                            Range</strong>. In the next lesson, you'll discover how to repeat code
                                        execution and
                                        iterate over collections.</p>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="strings.jsp" />
                                    <jsp:param name="prevTitle" value="Strings" />
                                    <jsp:param name="nextLink" value="loops-range.jsp" />
                                    <jsp:param name="nextTitle" value="Loops & Range" />
                                    <jsp:param name="currentLessonId" value="if-switch" />
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