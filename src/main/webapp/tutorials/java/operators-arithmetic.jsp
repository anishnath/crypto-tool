<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "operators-arithmetic" );
        request.setAttribute("currentModule", "Operators & Expressions" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Java Arithmetic Operators (+, -, *, /, %) - Java Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Learn how to use Java's arithmetic operators for addition, subtraction, multiplication, division, and modulo. Understand operator behavior with integers vs doubles.">
            <meta name="keywords"
                content="java arithmetic operators, java addition, java subtraction, java multiplication, java division, java modulo operator, java increment decrement">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Java Arithmetic Operators - Java Tutorial | 8gwifi.org">
            <meta property="og:description"
                content="Master Java's arithmetic operators with interactive examples. Learn about integer division and the modulo operator.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/java/operators-arithmetic.jsp">
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
    "name": "Java Arithmetic Operators",
    "description": "Guide to Java arithmetic operators including addition, subtraction, multiplication, division, and modulo.",
    "learningResourceType": "tutorial",
    "educationalLevel": "Beginner",
    "teaches": ["Arithmetic operators", "Integer division", "Modulo operator", "Increment/Decrement"],
    "timeRequired": "PT15M",
    "isPartOf": {
        "@type": "Course",
        "name": "Java Tutorial",
        "url": "https://8gwifi.org/tutorials/java/"
    }
}
</script>

            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="operators-arithmetic">
            <div class="tutorial-layout">
                <%@ include file="../tutorial-header.jsp" %>

                    <main class="tutorial-main">
                        <%@ include file="../tutorial-sidebar-java.jsp" %>
                            <div class="overlay" id="sidebarOverlay" onclick="toggleSidebar()"></div>

                            <article class="tutorial-content">
                                <nav class="breadcrumb">
                                    <a href="<%=request.getContextPath()%>/tutorials/">Tutorials</a>
                                    <span class="breadcrumb-separator">/</span>
                                    <a href="<%=request.getContextPath()%>/tutorials/java/">Java</a>
                                    <span class="breadcrumb-separator">/</span>
                                    <span>Arithmetic Operators</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Arithmetic Operators</h1>
                                    <div class="lesson-meta">
                                        <span>Beginner</span>
                                        <span>~15 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">Arithmetic operators are the foundation of mathematical processing
                                        in Java. They allow you to perform common mathematical operations like addition,
                                        subtraction, multiplication, division, and finding the remainder.</p>

                                    <!-- Section 1: Basic Operators -->
                                    <h2>Basic Arithmetic Operators</h2>
                                    <p>Java provides five basic arithmetic operators:</p>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Operator</th>
                                                <th>Name</th>
                                                <th>Description</th>
                                                <th>Example</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><code>+</code></td>
                                                <td>Addition</td>
                                                <td>Adds two values</td>
                                                <td><code>x + y</code></td>
                                            </tr>
                                            <tr>
                                                <td><code>-</code></td>
                                                <td>Subtraction</td>
                                                <td>Subtracts one value from another</td>
                                                <td><code>x - y</code></td>
                                            </tr>
                                            <tr>
                                                <td><code>*</code></td>
                                                <td>Multiplication</td>
                                                <td>Multiplies two values</td>
                                                <td><code>x * y</code></td>
                                            </tr>
                                            <tr>
                                                <td><code>/</code></td>
                                                <td>Division</td>
                                                <td>Divides one value by another</td>
                                                <td><code>x / y</code></td>
                                            </tr>
                                            <tr>
                                                <td><code>%</code></td>
                                                <td>Modulo</td>
                                                <td>Returns the division remainder</td>
                                                <td><code>x % y</code></td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="java/operators-arithmetic.java" />
                                        <jsp:param name="language" value="java" />
                                        <jsp:param name="editorId" value="compiler-arithmetic" />
                                    </jsp:include>

                                    <!-- Section 2: Integer vs. Floating-Point Division -->
                                    <h2>Integer vs. Floating-Point Division</h2>
                                    <p>It's crucial to understand how division works depending on the operand types.</p>

                                    <div class="info-box">
                                        <ul>
                                            <li><strong>Integer Division:</strong> If both operands are integers (e.g.,
                                                <code>int</code>), the result is an integer. Any decimal part is
                                                <strong>truncated</strong> (thrown away), not rounded.
                                                <br>Example: <code>5 / 2</code> equals <code>2</code> (not 2.5).
                                            </li>
                                            <li><strong>Floating-Point Division:</strong> If at least one operand is a
                                                floating-point type (e.g., <code>double</code> or <code>float</code>),
                                                the result is a floating-point number.
                                                <br>Example: <code>5.0 / 2</code> equals <code>2.5</code>.
                                            </li>
                                        </ul>
                                    </div>

                                    <img src="<%=request.getContextPath()%>/tutorials/assets/images/java-arithmetic-operators.svg"
                                        alt="Java Division and Modulo Diagram" class="diagram-image"
                                        style="max-width: 600px; margin: 2rem auto; display: block;">

                                    <!-- Section 3: The Modulo Operator -->
                                    <h2>The Modulo Operator (%)</h2>
                                    <p>The modulo operator returns the remainder of a division operation. It's
                                        incredibly useful for checking if a number is even or odd, or for cycling
                                        through values.</p>

                                    <pre><code class="language-java">int remainder = 10 % 3; // Result is 1 (10 / 3 = 3 with remainder 1)
int isEven = 4 % 2;     // Result is 0 (4 divides perfectly by 2)</code></pre>

                                    <!-- Section 4: Increment and Decrement -->
                                    <h2>Increment and Decrement</h2>
                                    <p>Java provides shortcut operators to increase or decrease a variable's value by 1.
                                    </p>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Operator</th>
                                                <th>Description</th>
                                                <th>Example (assume x = 5)</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><code>++x</code> (Prefix)</td>
                                                <td>Increments x, then uses the new value</td>
                                                <td><code>int y = ++x;</code> (x is 6, y is 6)</td>
                                            </tr>
                                            <tr>
                                                <td><code>x++</code> (Postfix)</td>
                                                <td>Uses the current value of x, then increments it</td>
                                                <td><code>int y = x++;</code> (y is 5, x is 6)</td>
                                            </tr>
                                            <tr>
                                                <td><code>--x</code> (Prefix)</td>
                                                <td>Decrements x, then uses the new value</td>
                                                <td><code>int y = --x;</code> (x is 4, y is 4)</td>
                                            </tr>
                                            <tr>
                                                <td><code>x--</code> (Postfix)</td>
                                                <td>Uses the current value of x, then decrements it</td>
                                                <td><code>int y = x--;</code> (y is 5, x is 4)</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li>Math operations work as expected: <code>+</code>, <code>-</code>,
                                                <code>*</code>.</li>
                                            <li>Division <code>/</code> truncates decimals if both numbers are integers.
                                            </li>
                                            <li>Modulo <code>%</code> gives the remainder.</li>
                                            <li><code>++</code> and <code>--</code> are shortcuts for adding/subtracting
                                                1.</li>
                                            <li>Be careful with postfix vs. prefix increment when using the result in an
                                                expression.</li>
                                        </ul>
                                    </div>

                                    <div style="margin-top: 3rem;">
                                        <% String prevLinkUrl=request.getContextPath()
                                            + "/tutorials/java/arrays-multidimensional.jsp" ; String
                                            nextLinkUrl=request.getContextPath()
                                            + "/tutorials/java/operators-comparison.jsp" ; %>
                                            <jsp:include page="../tutorial-nav.jsp">
                                                <jsp:param name="prevLink" value="<%=prevLinkUrl%>" />
                                                <jsp:param name="prevTitle" value="Multi-dimensional Arrays" />
                                                <jsp:param name="nextLink" value="<%=nextLinkUrl%>" />
                                                <jsp:param name="nextTitle" value="Comparison Operators →" />
                                                <jsp:param name="currentLessonId" value="operators-arithmetic" />
                                            </jsp:include>
                                    </div>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>
                            </article>
                    </main>

                    <%@ include file="../tutorial-footer.jsp" %>
            </div>

            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/clike.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/progress.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/tutorial-core.js?v=4"></script>
        </body>

        </html>