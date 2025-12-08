<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "operators-arithmetic");
   request.setAttribute("currentModule", "Operators & Arithmetic"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <title>Arithmetic Operations - Bash Tutorial | 8gwifi.org</title>
    <meta name="description"
        content="Learn Bash arithmetic operations including let, (( )), $(( )), and bc for calculations. Master addition, subtraction, multiplication, division, modulus, and exponentiation in shell scripts.">
    <meta name="keywords"
        content="bash arithmetic, bash math, bash let, bash expr, bash bc, shell script math, bash calculation, bash operators">

    <meta property="og:type" content="article">
    <meta property="og:title" content="Arithmetic Operations - Bash Tutorial">
    <meta property="og:description" content="Master Bash arithmetic operations with let, (( )), $(( )), and bc for integer and floating-point calculations.">
    <meta property="og:site_name" content="8gwifi.org Tutorials">

    <link rel="canonical" href="https://8gwifi.org/tutorials/bash/operators-arithmetic.jsp">
    <link rel="icon" type="image/svg+xml" href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
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
        "name": "Bash Arithmetic Operations",
        "description": "Learn Bash arithmetic operations including let, (( )), $(( )), and bc for calculations in shell scripts.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Beginner",
        "teaches": ["Arithmetic expansion $(())", "let command", "expr command", "bc calculator", "Integer operations", "Floating-point math", "Increment/decrement operators"],
        "timeRequired": "PT20M",
        "isPartOf": {
            "@type": "Course",
            "name": "Bash Tutorial",
            "url": "https://8gwifi.org/tutorials/bash/"
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
            <%@ include file="../tutorial-sidebar-bash.jsp" %>
            <div class="overlay" id="sidebarOverlay" onclick="toggleSidebar()"></div>

            <article class="tutorial-content">
                <nav class="breadcrumb">
                    <a href="<%=request.getContextPath()%>/tutorials/">Tutorials</a>
                    <span class="breadcrumb-separator">/</span>
                    <a href="<%=request.getContextPath()%>/tutorials/bash/">Bash</a>
                    <span class="breadcrumb-separator">/</span>
                    <span>Arithmetic Operations</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">Arithmetic Operations</h1>
                    <div class="lesson-meta">
                        <span>Beginner</span>
                        <span>~20 min read</span>
                    </div>
                </header>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="top" />
                </jsp:include>

                <div class="lesson-body">
                    <p class="lead">Bash provides several ways to perform arithmetic operations in your scripts. From simple addition to complex calculations, understanding these methods is essential for writing practical shell scripts. In this lesson, you'll learn about arithmetic expansion <code>\$(( ))</code>, the <code>let</code> command, the legacy <code>expr</code> command, and using <code>bc</code> for floating-point math.</p>

                    <!-- Section 1: Arithmetic Expansion -->
                    <h2>Arithmetic Expansion: \$(( ))</h2>
                    <p>The most common and recommended way to perform arithmetic in Bash is using <strong>arithmetic expansion</strong> with <code>\$(( ))</code>. This syntax evaluates the expression and returns the result.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="bash/operators-arithmetic.sh" />
                        <jsp:param name="language" value="bash" />
                        <jsp:param name="editorId" value="compiler-arithmetic" />
                    </jsp:include>

                    <table class="info-table">
                        <thead>
                            <tr>
                                <th>Operator</th>
                                <th>Description</th>
                                <th>Example</th>
                                <th>Result</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><code>+</code></td>
                                <td>Addition</td>
                                <td><code>\$((5 + 3))</code></td>
                                <td>8</td>
                            </tr>
                            <tr>
                                <td><code>-</code></td>
                                <td>Subtraction</td>
                                <td><code>\$((5 - 3))</code></td>
                                <td>2</td>
                            </tr>
                            <tr>
                                <td><code>*</code></td>
                                <td>Multiplication</td>
                                <td><code>\$((5 * 3))</code></td>
                                <td>15</td>
                            </tr>
                            <tr>
                                <td><code>/</code></td>
                                <td>Division (integer)</td>
                                <td><code>\$((10 / 3))</code></td>
                                <td>3</td>
                            </tr>
                            <tr>
                                <td><code>%</code></td>
                                <td>Modulus (remainder)</td>
                                <td><code>\$((10 % 3))</code></td>
                                <td>1</td>
                            </tr>
                            <tr>
                                <td><code>**</code></td>
                                <td>Exponentiation</td>
                                <td><code>\$((2 ** 3))</code></td>
                                <td>8</td>
                            </tr>
                        </tbody>
                    </table>

                    <div class="info-box">
                        <strong>Key Point:</strong> Inside <code>\$(( ))</code>, you don't need the <code>$</code> prefix for variables. Both <code>\$((a + b))</code> and <code>\$((\$a + \$b))</code> work, but the first is cleaner and preferred.
                    </div>

                    <!-- Section 2: The let Command -->
                    <h2>The let Command</h2>
                    <p>The <code>let</code> command is another way to perform arithmetic. It evaluates expressions and assigns the result to variables. It's particularly useful for increment/decrement operations.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="bash/operators-arithmetic-let.sh" />
                        <jsp:param name="language" value="bash" />
                        <jsp:param name="editorId" value="compiler-let" />
                    </jsp:include>

                    <div class="tip-box">
                        <strong>Pro Tip:</strong> Use <code>(( ))</code> (without the <code>$</code>) as a shorthand for <code>let</code>. For example, <code>((count++))</code> is equivalent to <code>let count++</code>. The <code>(( ))</code> form is often preferred for conditions and loops!
                    </div>

                    <jsp:include page="../tutorial-ad-slot.jsp">
                        <jsp:param name="slot" value="middle" />
                    </jsp:include>

                    <!-- Section 3: The expr Command (Legacy) -->
                    <h2>The expr Command (Legacy)</h2>
                    <p>The <code>expr</code> command is an older, POSIX-compliant method for arithmetic. While still functional, it's considered legacy. You'll encounter it in older scripts, so it's good to understand it.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="bash/operators-arithmetic-expr.sh" />
                        <jsp:param name="language" value="bash" />
                        <jsp:param name="editorId" value="compiler-expr" />
                    </jsp:include>

                    <div class="warning-box">
                        <strong>Caution:</strong> When using <code>expr</code>:
                        <ul>
                            <li>Spaces are <strong>required</strong> around operators: <code>expr 5 + 3</code> (not <code>expr 5+3</code>)</li>
                            <li>Multiplication needs escaping: <code>expr 5 \* 3</code> (the <code>*</code> is a glob character)</li>
                            <li>Modern scripts should prefer <code>\$(( ))</code> instead</li>
                        </ul>
                    </div>

                    <!-- Section 4: Floating-Point with bc -->
                    <h2>Floating-Point Arithmetic with bc</h2>
                    <p>Bash only supports integer arithmetic natively. For floating-point (decimal) calculations, use the <code>bc</code> (basic calculator) command. It's a powerful tool for precision math!</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="bash/operators-arithmetic-bc.sh" />
                        <jsp:param name="language" value="bash" />
                        <jsp:param name="editorId" value="compiler-bc" />
                    </jsp:include>

                    <div class="info-box">
                        <strong>Understanding bc:</strong>
                        <ul>
                            <li><code>scale=N</code> sets the number of decimal places</li>
                            <li>Pipe the expression to bc: <code>echo "expression" | bc</code></li>
                            <li>bc supports functions like <code>sqrt()</code>, <code>s()</code> (sine), <code>c()</code> (cosine)</li>
                            <li>For math functions, use <code>bc -l</code> (load math library)</li>
                        </ul>
                    </div>

                    <!-- Section 5: Assignment Operators -->
                    <h2>Assignment Operators</h2>
                    <p>Bash supports compound assignment operators for modifying variables in place. These combine an arithmetic operation with assignment.</p>

                    <pre><code class="language-bash"># Compound assignment operators
x=10

((x += 5))   # x = x + 5  -> x is now 15
((x -= 3))   # x = x - 3  -> x is now 12
((x *= 2))   # x = x * 2  -> x is now 24
((x /= 4))   # x = x / 4  -> x is now 6
((x %= 4))   # x = x % 4  -> x is now 2
((x **= 3))  # x = x ** 3 -> x is now 8

# Increment and decrement
((x++))      # Post-increment: use then add 1
((++x))      # Pre-increment: add 1 then use
((x--))      # Post-decrement: use then subtract 1
((--x))      # Pre-decrement: subtract 1 then use</code></pre>

                    <div class="tip-box">
                        <strong>Pro Tip:</strong> The difference between <code>((x++))</code> and <code>((++x))</code> matters when used in expressions. Pre-increment changes the value <em>before</em> it's used; post-increment changes it <em>after</em>.
                    </div>

                    <!-- Common Mistakes -->
                    <h2>Common Mistakes</h2>

                    <div class="mistake-box">
                        <h4>1. Spaces in assignments</h4>
                        <pre><code class="language-bash"># Wrong - spaces cause errors
x = 10         # Error: command not found
x= 10          # Error: command not found

# Correct - no spaces around =
x=10
result=\$((5 + 3))</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>2. Expecting floating-point results</h4>
                        <pre><code class="language-bash"># Wrong - Bash integer division truncates
result=\$((10 / 3))
echo \$result  # Output: 3 (not 3.333)

# Correct - use bc for decimals
result=\$(echo "scale=2; 10 / 3" | bc)
echo \$result  # Output: 3.33</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>3. Forgetting to escape * in expr</h4>
                        <pre><code class="language-bash"># Wrong - * expands to filenames
result=\$(expr 5 * 3)  # Error or unexpected results

# Correct - escape the asterisk
result=\$(expr 5 \* 3)  # Output: 15

# Better - use \$(( )) instead
result=\$((5 * 3))  # Output: 15</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>4. Using $ inside (( )) when not needed</h4>
                        <pre><code class="language-bash"># Works but verbose
a=5; b=3
result=\$((\$a + \$b))

# Cleaner - $ is optional inside (( ))
result=\$((a + b))</code></pre>
                    </div>

                    <!-- Exercise -->
                    <h2>Exercise: Build a Calculator</h2>
                    <div class="exercise-section">
                        <p><strong>Task:</strong> Create a simple calculator script that demonstrates various arithmetic operations!</p>

                        <p><strong>Requirements:</strong></p>
                        <ul>
                            <li>Define two numbers as variables</li>
                            <li>Perform all 6 basic operations (+, -, *, /, %, **)</li>
                            <li>Use compound operators (++, +=)</li>
                            <li>Calculate a floating-point result using bc</li>
                        </ul>

                        <details class="exercise-hint">
                            <summary>Show Solution</summary>
                            <pre><code class="language-bash">#!/bin/bash
# Simple Calculator

# Define numbers
num1=15
num2=4
echo "=== Simple Calculator ==="
echo "Numbers: num1=\$num1, num2=\$num2"
echo ""

# Basic operations
echo "--- Basic Operations ---"
echo "Addition: \$num1 + \$num2 = \$((num1 + num2))"
echo "Subtraction: \$num1 - \$num2 = \$((num1 - num2))"
echo "Multiplication: \$num1 * \$num2 = \$((num1 * num2))"
echo "Division: \$num1 / \$num2 = \$((num1 / num2))"
echo "Modulus: \$num1 % \$num2 = \$((num1 % num2))"
echo "Power: \$num1 ** 2 = \$((num1 ** 2))"
echo ""

# Compound operators
echo "--- Compound Operators ---"
counter=0
echo "Starting counter=\$counter"
((counter++))
echo "After counter++: \$counter"
((counter+=10))
echo "After counter+=10: \$counter"
echo ""

# Floating-point with bc
echo "--- Floating-Point (bc) ---"
float_result=\$(echo "scale=4; \$num1 / \$num2" | bc)
echo "Precise division: \$num1 / \$num2 = \$float_result"</code></pre>
                        </details>
                    </div>

                    <!-- Summary -->
                    <h2>Summary</h2>
                    <div class="summary-box">
                        <ul>
                            <li><strong>Arithmetic Expansion:</strong> <code>\$(( ))</code> is the modern, preferred method for integer math</li>
                            <li><strong>let Command:</strong> <code>let x=5+3</code> for arithmetic assignments and increments</li>
                            <li><strong>(( )) Syntax:</strong> Same as let but cleaner: <code>((x++))</code></li>
                            <li><strong>expr Command:</strong> Legacy method, requires spaces and escaping</li>
                            <li><strong>bc Calculator:</strong> Use for floating-point: <code>echo "scale=2; 10/3" | bc</code></li>
                            <li><strong>Operators:</strong> +, -, *, /, %, ** for basic math</li>
                            <li><strong>Compound Operators:</strong> +=, -=, *=, /=, %=, ++, -- for in-place modification</li>
                        </ul>
                    </div>

                    <h2>What's Next?</h2>
                    <p>Now that you can perform calculations, let's learn about <strong>Comparison Operators</strong>. You'll discover how to compare numbers and strings, which is essential for conditional statements and decision-making in your scripts!</p>
                </div>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="bottom" />
                </jsp:include>

                <jsp:include page="../tutorial-nav.jsp">
                    <jsp:param name="prevLink" value="strings-heredoc.jsp" />
                    <jsp:param name="prevTitle" value="Here Documents" />
                    <jsp:param name="nextLink" value="operators-comparison.jsp" />
                    <jsp:param name="nextTitle" value="Comparison Operators" />
                    <jsp:param name="currentLessonId" value="operators-arithmetic" />
                </jsp:include>
            </article>
        </main>

        <%@ include file="../tutorial-footer.jsp" %>
    </div>

    <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror.min.js"></script>
    <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/shell.min.js"></script>
    <script src="<%=request.getContextPath()%>/tutorials/assets/js/progress.js"></script>
    <script src="<%=request.getContextPath()%>/tutorials/assets/js/tutorial-core.js?v=4"></script>
</body>

</html>
