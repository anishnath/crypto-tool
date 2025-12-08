<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "operators-bitwise");
   request.setAttribute("currentModule", "Operators"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <title>Bitwise Operators - Python Tutorial | 8gwifi.org</title>
    <meta name="description"
        content="Master Python bitwise operators: AND, OR, XOR, NOT, and bit shifts. Learn binary numbers, permission flags, and practical applications with examples.">
    <meta name="keywords"
        content="python bitwise operators, python binary operations, python AND OR XOR, python bit shift, python binary numbers">

    <meta property="og:type" content="article">
    <meta property="og:title" content="Bitwise Operators - Python Tutorial | 8gwifi.org">
    <meta property="og:description" content="Master Python bitwise operators with interactive examples.">
    <meta property="og:site_name" content="8gwifi.org Tutorials">

    <link rel="canonical" href="https://8gwifi.org/tutorials/python/operators-bitwise.jsp">
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
        "name": "Python Bitwise Operators",
        "description": "Master Python bitwise operators: AND, OR, XOR, NOT, and bit shifts with practical examples.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Intermediate",
        "teaches": ["Bitwise AND, OR, XOR, NOT", "Binary number system", "Left and right bit shifts", "Permission flags", "Practical bit manipulation"],
        "timeRequired": "PT20M",
        "isPartOf": {
            "@type": "Course",
            "name": "Python Tutorial",
            "url": "https://8gwifi.org/tutorials/python/"
        }
    }
    </script>

    <%@ include file="../tutorial-ads.jsp" %>
    <%@ include file="../tutorial-analytics.jsp" %>
</head>

<body class="tutorial-body no-preview" data-lesson="operators-bitwise">
    <div class="tutorial-layout">
        <%@ include file="../tutorial-header.jsp" %>

        <main class="tutorial-main">
            <%@ include file="../tutorial-sidebar-python.jsp" %>
            <div class="overlay" id="sidebarOverlay" onclick="toggleSidebar()"></div>

            <article class="tutorial-content">
                <nav class="breadcrumb">
                    <a href="<%=request.getContextPath()%>/tutorials/">Tutorials</a>
                    <span class="breadcrumb-separator">/</span>
                    <a href="<%=request.getContextPath()%>/tutorials/python/">Python</a>
                    <span class="breadcrumb-separator">/</span>
                    <span>Bitwise Operators</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">Bitwise Operators</h1>
                    <div class="lesson-meta">
                        <span>Intermediate</span>
                        <span>~20 min read</span>
                    </div>
                </header>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="top" />
                </jsp:include>

                <div class="lesson-body">
                    <p class="lead">Bitwise operators work directly on the binary representation of numbers,
                    manipulating individual bits. While they might seem low-level, they're essential for
                    permission systems, flags, cryptography, and performance optimizations!</p>

                    <!-- Section 1: Understanding Binary -->
                    <h2>Understanding Binary Numbers</h2>
                    <p>Before diving into bitwise operators, let's understand how numbers are represented in binary.
                    Each digit (bit) can be 0 or 1, and each position represents a power of 2.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/operators-bitwise-binary.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-binary" />
                    </jsp:include>

                    <div class="info-box">
                        <strong>Key Point:</strong> Python prefixes binary numbers with <code>0b</code>.
                        Use <code>bin()</code> to convert decimal to binary, and <code>int('1010', 2)</code>
                        to convert binary strings to decimal.
                    </div>

                    <!-- Section 2: Bitwise Operators -->
                    <h2>The Six Bitwise Operators</h2>
                    <p>Python has six bitwise operators that work on the binary representation of integers.</p>

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
                            <tr><td><code>&amp;</code></td><td>AND</td><td>1 if BOTH bits are 1</td><td><code>5 &amp; 3 = 1</code></td></tr>
                            <tr><td><code>|</code></td><td>OR</td><td>1 if AT LEAST ONE bit is 1</td><td><code>5 | 3 = 7</code></td></tr>
                            <tr><td><code>^</code></td><td>XOR</td><td>1 if bits are DIFFERENT</td><td><code>5 ^ 3 = 6</code></td></tr>
                            <tr><td><code>~</code></td><td>NOT</td><td>Inverts all bits</td><td><code>~5 = -6</code></td></tr>
                            <tr><td><code>&lt;&lt;</code></td><td>Left Shift</td><td>Shifts bits left (multiply by 2^n)</td><td><code>5 &lt;&lt; 1 = 10</code></td></tr>
                            <tr><td><code>&gt;&gt;</code></td><td>Right Shift</td><td>Shifts bits right (divide by 2^n)</td><td><code>5 &gt;&gt; 1 = 2</code></td></tr>
                        </tbody>
                    </table>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/operators-bitwise-basic.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-basic" />
                    </jsp:include>

                    <div class="tip-box">
                        <strong>Visual Tip:</strong> Line up the binary digits vertically when working with
                        bitwise operations. Compare each column independently: AND needs both 1s, OR needs
                        at least one 1, XOR needs exactly one 1.
                    </div>

                    <jsp:include page="../tutorial-ad-slot.jsp">
                        <jsp:param name="slot" value="middle" />
                    </jsp:include>

                    <!-- Section 3: Bit Shifting -->
                    <h2>Bit Shifting</h2>
                    <p>Shift operators move all bits left or right by a specified number of positions.
                    This is equivalent to multiplying or dividing by powers of 2!</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/operators-bitwise-shifts.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-shifts" />
                    </jsp:include>

                    <div class="warning-box">
                        <strong>Caution:</strong> Right shifting a negative number in Python preserves the sign
                        (arithmetic shift). Also, shifting by negative amounts or extremely large values can
                        cause unexpected results. Always validate your shift amounts!
                    </div>

                    <!-- Section 4: Practical Applications -->
                    <h2>Practical Applications</h2>
                    <p>Bitwise operators are commonly used for permission systems, flags, efficient math,
                    and clever algorithms.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/operators-bitwise-practical.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-practical" />
                    </jsp:include>

                    <div class="tip-box">
                        <strong>Common Uses:</strong>
                        <ul style="margin: 0.5rem 0 0 1.5rem;">
                            <li><code>n &amp; 1</code> - Check if odd (faster than <code>n % 2</code>)</li>
                            <li><code>n &lt;&lt; 1</code> - Multiply by 2 (faster than <code>n * 2</code>)</li>
                            <li><code>flags | FLAG</code> - Set a flag</li>
                            <li><code>flags &amp; ~FLAG</code> - Clear a flag</li>
                            <li><code>flags ^ FLAG</code> - Toggle a flag</li>
                        </ul>
                    </div>

                    <!-- Common Mistakes -->
                    <h2>Common Mistakes</h2>

                    <div class="mistake-box">
                        <h4>1. Confusing & with and, | with or</h4>
                        <pre><code class="language-python"># Wrong - these are different!
if a & b:  # Bitwise AND (compares bits)
if a and b:  # Logical AND (checks truthiness)

# Examples:
a, b = 2, 4
print(a & b)   # 0 (no common bits)
print(a and b) # 4 (both truthy, returns last)</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>2. Forgetting operator precedence</h4>
                        <pre><code class="language-python"># Wrong - comparison has higher precedence!
if x & 1 == 1:  # Parsed as: x & (1 == 1) → x & True → x & 1
    pass

# Correct - use parentheses
if (x & 1) == 1:
    pass</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>3. Unexpected NOT (~) results</h4>
                        <pre><code class="language-python"># Surprise! NOT doesn't give what you might expect
x = 5
print(~x)  # -6, not what you might expect!

# This is because Python uses two's complement
# ~x = -(x + 1) for all integers</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>4. Using ^ for exponentiation</h4>
                        <pre><code class="language-python"># Wrong - ^ is XOR, not power!
result = 2 ^ 3  # 1 (XOR), not 8!

# Correct - use ** for exponentiation
result = 2 ** 3  # 8</code></pre>
                    </div>

                    <!-- Exercise -->
                    <h2>Exercise: Permission System</h2>
                    <div class="exercise-section">
                        <p><strong>Task:</strong> Implement a permission system using bitwise operators.</p>

                        <p><strong>Requirements:</strong></p>
                        <ul>
                            <li>Grant READ and WRITE permissions using OR (<code>|</code>)</li>
                            <li>Check if user has WRITE permission using AND (<code>&amp;</code>)</li>
                            <li>Revoke WRITE permission using AND (<code>&amp;</code>) and NOT (<code>~</code>)</li>
                            <li>Toggle EXECUTE permission using XOR (<code>^</code>)</li>
                        </ul>

                        <jsp:include page="../tutorial-compiler.jsp">
                            <jsp:param name="codeFile" value="python/exercises/ex-operators-bitwise.py" />
                            <jsp:param name="language" value="python" />
                            <jsp:param name="editorId" value="exercise-bitwise" />
                        </jsp:include>

                        <details class="exercise-hint">
                            <summary>Show Solution</summary>
                            <pre><code class="language-python"># Permission flags
READ_PERMISSION = 4     # 100
WRITE_PERMISSION = 2    # 010
EXECUTE_PERMISSION = 1  # 001

user_permissions = 0

# 1. Grant READ and WRITE permissions
user_permissions = user_permissions | READ_PERMISSION | WRITE_PERMISSION
print(f"After granting R+W: {user_permissions:03b}")  # 110

# 2. Check if user has WRITE permission
has_write = bool(user_permissions & WRITE_PERMISSION)
print(f"Has WRITE? {has_write}")  # True

# 3. Revoke WRITE permission
user_permissions = user_permissions & ~WRITE_PERMISSION
print(f"After revoking W: {user_permissions:03b}")  # 100

# 4. Toggle EXECUTE permission
user_permissions = user_permissions ^ EXECUTE_PERMISSION
print(f"After toggling X: {user_permissions:03b}")  # 101</code></pre>
                        </details>
                    </div>

                    <!-- Summary -->
                    <h2>Summary</h2>
                    <div class="summary-box">
                        <ul>
                            <li><strong>&amp;</strong> (AND) - 1 only if both bits are 1</li>
                            <li><strong>|</strong> (OR) - 1 if at least one bit is 1</li>
                            <li><strong>^</strong> (XOR) - 1 if bits are different</li>
                            <li><strong>~</strong> (NOT) - Inverts all bits (gives -(n+1))</li>
                            <li><strong>&lt;&lt;</strong> - Left shift multiplies by 2^n</li>
                            <li><strong>&gt;&gt;</strong> - Right shift divides by 2^n</li>
                            <li><strong>Use cases:</strong> Permission flags, efficient math, finding unique elements</li>
                        </ul>
                    </div>

                    <h2>What's Next?</h2>
                    <p>Now that you understand bitwise operations, let's learn about <strong>membership operators</strong>
                    (<code>in</code> and <code>not in</code>) - simple but powerful operators for checking if values
                    exist in sequences like lists, strings, and dictionaries.</p>
                </div>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="bottom" />
                </jsp:include>

                <jsp:include page="../tutorial-nav.jsp">
                    <jsp:param name="prevLink" value="operators-assignment.jsp" />
                    <jsp:param name="prevTitle" value="Assignment Operators" />
                    <jsp:param name="nextLink" value="operators-membership.jsp" />
                    <jsp:param name="nextTitle" value="Membership Operators" />
                    <jsp:param name="currentLessonId" value="operators-bitwise" />
                </jsp:include>
            </article>
        </main>

        <%@ include file="../tutorial-footer.jsp" %>
    </div>

    <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror.min.js"></script>
    <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/python.min.js"></script>
    <script src="<%=request.getContextPath()%>/tutorials/assets/js/progress.js"></script>
    <script src="<%=request.getContextPath()%>/tutorials/assets/js/tutorial-core.js?v=4"></script>
</body>

</html>
