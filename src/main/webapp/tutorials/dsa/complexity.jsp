<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "complexity" );
        request.setAttribute("currentModule", "Introduction & Fundamentals" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Time & Space Complexity - DSA Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Master Big O notation and learn to analyze time and space complexity of algorithms. Understand O(1), O(log n), O(n), O(n²), and more with interactive examples.">
            <meta name="keywords"
                content="big o notation, time complexity, space complexity, algorithm analysis, O(n), O(log n), DSA tutorial">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Time & Space Complexity - DSA Tutorial | 8gwifi.org">
            <meta property="og:description"
                content="Learn Big O notation and algorithm complexity analysis with interactive visualizations.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/dsa/complexity.jsp">
            <link rel="icon" type="image/svg+xml"
                href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial-server.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror.min.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/monokai.min.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/dsa/styles/visualization.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/dsa/styles/bigo-viz.css">

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
        "name": "Time and Space Complexity Analysis",
        "description": "Learn to analyze algorithm efficiency using Big O notation. Master time and space complexity with interactive examples.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Beginner",
        "teaches": ["Big O Notation", "Time Complexity", "Space Complexity", "Algorithm Analysis", "Complexity Classes"],
        "timeRequired": "PT25M",
        "isPartOf": {
            "@type": "Course",
            "name": "Data Structures and Algorithms Tutorial",
            "url": "https://8gwifi.org/tutorials/dsa/"
        }
    }
    </script>

            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="complexity">
            <div class="tutorial-layout">
                <%@ include file="../tutorial-header.jsp" %>

                    <main class="tutorial-main">
                        <%@ include file="../tutorial-sidebar-dsa.jsp" %>
                            <div class="overlay" id="sidebarOverlay" onclick="toggleSidebar()"></div>

                            <article class="tutorial-content">
                                <nav class="breadcrumb">
                                    <a href="<%=request.getContextPath()%>/tutorials/">Tutorials</a>
                                    <span class="breadcrumb-separator">/</span>
                                    <a href="<%=request.getContextPath()%>/tutorials/dsa/">DSA</a>
                                    <span class="breadcrumb-separator">/</span>
                                    <span>Time & Space Complexity</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">⏱️ Time & Space Complexity</h1>
                                    <div class="lesson-meta">
                                        <span>Beginner</span>
                                        <span>~25 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">Your API got sluggish after users doubled — is the culprit an
                                        O(n²) loop or a costly data structure? In this lesson, you'll learn Big O
                                        notation — the universal language for describing algorithm performance — and how
                                        to analyze both time and space complexity so you can diagnose and fix issues
                                        like this with confidence.</p>
                                    <p>This builds on your foundation from the introduction.</p>

                                    <!-- Story Section -->
                                    <div class="warning-box" style="margin: var(--space-8) 0;">
                                        <h3 style="margin-top: 0;">⚠️ The Startup That Almost Died</h3>
                                        <p><strong>Day 1:</strong> Sarah launches her photo-sharing app. 100 users.
                                            Everything works perfectly. Response time: 50ms. ✅</p>

                                        <p><strong>Day 30:</strong> App goes viral! 10,000 users. Suddenly, loading
                                            photos takes 5 seconds. Users complain. Servers crash. 💥</p>

                                        <p><strong>The Problem:</strong> Sarah's code checked every user against every
                                            other user to find mutual friends. That's O(n²)!</p>

                                        <p><strong>The Fix:</strong> A senior developer rewrote it using a hash table.
                                            Same feature, O(n) complexity. Response time back to 50ms. Company saved. 🎉
                                        </p>

                                        <p style="margin-bottom: 0;"><strong>The Lesson:</strong> Big O isn't academic
                                            theory—it's the difference between a successful app and a failed startup.
                                        </p>
                                    </div>

                                    <!-- Visual Growth Comparison SVG -->
                                    <div
                                        style="background: var(--bg-secondary); border-radius: var(--radius-lg); padding: var(--space-6); margin: var(--space-8) 0;">
                                        <h3 style="text-align: center; margin-top: 0;">How Algorithms Scale: Sarah's App
                                        </h3>
                                        <svg viewBox="0 0 900 500"
                                            style="width: 100%; max-width: 900px; height: auto; display: block; margin: 0 auto;">
                                            <!-- Grid lines -->
                                            <line x1="80" y1="400" x2="850" y2="400" stroke="var(--border)"
                                                stroke-width="2" />
                                            <line x1="80" y1="400" x2="80" y2="50" stroke="var(--border)"
                                                stroke-width="2" />

                                            <!-- Y-axis labels -->
                                            <text x="70" y="405" text-anchor="end" fill="var(--text-muted)"
                                                font-size="12">0s</text>
                                            <text x="70" y="305" text-anchor="end" fill="var(--text-muted)"
                                                font-size="12">1s</text>
                                            <text x="70" y="205" text-anchor="end" fill="var(--text-muted)"
                                                font-size="12">2s</text>
                                            <text x="70" y="105" text-anchor="end" fill="var(--text-muted)"
                                                font-size="12">3s</text>
                                            <text x="70" y="55" text-anchor="end" fill="var(--text-muted)"
                                                font-size="12">4s</text>

                                            <!-- X-axis labels -->
                                            <text x="80" y="425" text-anchor="middle" fill="var(--text-muted)"
                                                font-size="12">100</text>
                                            <text x="273" y="425" text-anchor="middle" fill="var(--text-muted)"
                                                font-size="12">1K</text>
                                            <text x="466" y="425" text-anchor="middle" fill="var(--text-muted)"
                                                font-size="12">5K</text>
                                            <text x="659" y="425" text-anchor="middle" fill="var(--text-muted)"
                                                font-size="12">10K</text>
                                            <text x="850" y="425" text-anchor="middle" fill="var(--text-muted)"
                                                font-size="12">20K</text>

                                            <!-- Axis titles -->
                                            <text x="465" y="460" text-anchor="middle" fill="var(--text-primary)"
                                                font-size="14" font-weight="600">
                                                Number of Users
                                            </text>
                                            <text x="30" y="230" text-anchor="middle" fill="var(--text-primary)"
                                                font-size="14" font-weight="600" transform="rotate(-90 30 230)">
                                                Response Time
                                            </text>

                                            <!-- O(1) - Constant (flat line) -->
                                            <path d="M 80 395 L 850 395" fill="none" stroke="#51cf66" stroke-width="3"
                                                opacity="0.8" />
                                            <circle cx="850" cy="395" r="5" fill="#51cf66" />
                                            <text x="860" y="395" fill="#51cf66" font-size="13" font-weight="600">O(1) -
                                                Hash lookup</text>

                                            <!-- O(n) - Linear (gentle slope) -->
                                            <path d="M 80 395 Q 273 375, 466 340 T 850 250" fill="none" stroke="#4dabf7"
                                                stroke-width="3" opacity="0.8" />
                                            <circle cx="850" cy="250" r="5" fill="#4dabf7" />
                                            <text x="860" y="250" fill="#4dabf7" font-size="13" font-weight="600">O(n) -
                                                Fixed version</text>

                                            <!-- O(n²) - Quadratic (steep curve) -->
                                            <path d="M 80 395 Q 273 350, 466 180 T 659 60 L 700 50" fill="none"
                                                stroke="#ff6b6b" stroke-width="3" opacity="0.8" />
                                            <circle cx="659" cy="60" r="5" fill="#ff6b6b" />
                                            <text x="669" y="60" fill="#ff6b6b" font-size="13" font-weight="600">O(n²) -
                                                Original bug</text>

                                            <!-- Annotations -->
                                            <!-- Day 1 marker -->
                                            <line x1="80" y1="395" x2="80" y2="380" stroke="var(--success)"
                                                stroke-width="2" stroke-dasharray="5,5" />
                                            <text x="80" y="370" text-anchor="middle" fill="var(--success)"
                                                font-size="11" font-weight="600">Day 1</text>
                                            <text x="80" y="383" text-anchor="middle" fill="var(--success)"
                                                font-size="10">✅ Fast</text>

                                            <!-- Day 30 marker (crash point) -->
                                            <line x1="659" y1="60" x2="659" y2="30" stroke="var(--error)"
                                                stroke-width="2" stroke-dasharray="5,5" />
                                            <text x="659" y="25" text-anchor="middle" fill="var(--error)" font-size="11"
                                                font-weight="600">Day 30</text>
                                            <text x="659" y="15" text-anchor="middle" fill="var(--error)"
                                                font-size="10">💥 Crash!</text>

                                            <!-- "Acceptable" zone -->
                                            <rect x="80" y="350" width="770" height="50" fill="#51cf66" opacity="0.1" />
                                            <text x="465" y="375" text-anchor="middle" fill="var(--text-muted)"
                                                font-size="11" font-style="italic">
                                                Acceptable Performance Zone
                                            </text>
                                        </svg>

                                        <div
                                            style="margin-top: var(--space-6); display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: var(--space-4);">
                                            <div
                                                style="padding: var(--space-3); background: rgba(255, 107, 107, 0.1); border-left: 4px solid #ff6b6b; border-radius: var(--radius-md);">
                                                <strong style="color: #ff6b6b;">❌ O(n²) - Original Code</strong>
                                                <p
                                                    style="margin: var(--space-1) 0 0; font-size: var(--text-sm); color: var(--text-secondary);">
                                                    100 users = 0.05s<br>
                                                    10,000 users = 5s 💥<br>
                                                    <em>Exponential growth kills scalability</em>
                                                </p>
                                            </div>
                                            <div
                                                style="padding: var(--space-3); background: rgba(77, 171, 247, 0.1); border-left: 4px solid #4dabf7; border-radius: var(--radius-md);">
                                                <strong style="color: #4dabf7;">✅ O(n) - After Fix</strong>
                                                <p
                                                    style="margin: var(--space-1) 0 0; font-size: var(--text-sm); color: var(--text-secondary);">
                                                    100 users = 0.05s<br>
                                                    10,000 users = 0.08s ✅<br>
                                                    <em>Linear growth is manageable</em>
                                                </p>
                                            </div>
                                            <div
                                                style="padding: var(--space-3); background: rgba(81, 207, 102, 0.1); border-left: 4px solid #51cf66; border-radius: var(--radius-md);">
                                                <strong style="color: #51cf66;">🚀 O(1) - Best Case</strong>
                                                <p
                                                    style="margin: var(--space-1) 0 0; font-size: var(--text-sm); color: var(--text-secondary);">
                                                    100 users = 0.05s<br>
                                                    10,000 users = 0.05s 🎉<br>
                                                    <em>Constant time, infinite scale</em>
                                                </p>
                                            </div>
                                        </div>

                                        <p
                                            style="text-align: center; color: var(--text-secondary); margin-top: var(--space-4); margin-bottom: 0;">
                                            <strong>The takeaway:</strong> Algorithm choice determines whether your app
                                            scales to millions or crashes at thousands.
                                        </p>
                                    </div>

                                    <!-- Section 1: What is Time Complexity? -->
                                    <h2>What is Time Complexity?</h2>

                                    <p>Time complexity measures how the runtime of an algorithm grows as the input size
                                        increases. It's not about measuring exact seconds - it's about understanding the
                                        <strong>growth rate</strong>.
                                    </p>

                                    <div class="info-box">
                                        <h4>📚 Real-World Analogy</h4>
                                        <p>Imagine you're looking for a book in a library:</p>
                                        <ul>
                                            <li><strong>Method 1:</strong> Check every shelf one by one (slow, grows
                                                with library size)</li>
                                            <li><strong>Method 2:</strong> Use the catalog system (fast, doesn't grow
                                                much with library size)</li>
                                        </ul>
                                        <p>Time complexity helps us compare these methods mathematically!</p>
                                    </div>

                                    <h3>Why Time Complexity Matters</h3>
                                    <ul>
                                        <li><strong>Scalability:</strong> Will your code work with 1 million users? 1
                                            billion?</li>
                                        <li><strong>Performance:</strong> Avoid slow algorithms that frustrate users
                                        </li>
                                        <li><strong>Resource Costs:</strong> Faster algorithms = lower server costs</li>
                                        <li><strong>Interviews:</strong> Every tech interview asks about Big O!</li>
                                    </ul>

                                    <!-- Section 2: Big O Notation -->
                                    <h2>Big O Notation Explained</h2>

                                    <p>Big O notation describes the <strong>worst-case</strong> growth rate of an
                                        algorithm. It answers: "How does runtime change when input size doubles?"</p>

                                    <div class="info-box">
                                        <h4>🎯 Key Principle</h4>
                                        <p>Big O focuses on the <strong>dominant term</strong> and ignores constants:
                                        </p>
                                        <ul>
                                            <li><code>3n + 5</code> → <code>O(n)</code> (drop constants)</li>
                                            <li><code>n² + 100n + 50</code> → <code>O(n²)</code> (n² dominates)</li>
                                            <li><code>5</code> → <code>O(1)</code> (constant)</li>
                                        </ul>
                                    </div>

                                    <h3>Quick Quiz: Drop What Doesn’t Matter</h3>
                                    <p>Apply the Big O rules to simplify these. Reveal to check yourself.</p>
                                    <ul>
                                        <li>
                                            <code>7n + 3</code>
                                            <details>
                                                <summary>Show answer</summary>
                                                Drop constants → <strong>O(n)</strong>
                                            </details>
                                        </li>
                                        <li>
                                            <code>n² + 50n + 500</code>
                                            <details>
                                                <summary>Show answer</summary>
                                                n² dominates → <strong>O(n²)</strong>
                                            </details>
                                        </li>
                                        <li>
                                            <code>n log n + n</code>
                                            <details>
                                                <summary>Show answer</summary>
                                                n log n dominates → <strong>O(n log n)</strong>
                                            </details>
                                        </li>
                                    </ul>

                                    <!-- Big O Visualization -->
                                    <h2>Big O Growth Comparison</h2>
                                    <p>See how different complexities grow as input size increases. Play the animation
                                        to watch the curves grow!</p>

                                    <div class="visualization-container">
                                        <div id="bigoVisualization"></div>
                                    </div>

                                    <div class="tip-box">
                                        <strong>Pro Tip:</strong> Use the slider to see exact operation counts at
                                        different input sizes. Notice how O(2ⁿ) explodes while O(1) stays flat!
                                    </div>

                                    <div class="info-box">
                                        <h4>Analogy Check: Library Search</h4>
                                        <p>Checking every shelf is like <strong>O(n)</strong>; using the catalog to
                                            jump to the right shelf is like <strong>O(log n)</strong>. As your library
                                            (n) grows, the difference becomes dramatic.</p>
                                    </div>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <!-- Section 3: Common Complexity Classes -->
                                    <h2>Common Complexity Classes</h2>

                                    <p>You'll explore each complexity class with real code you can run.</p>

                                    <h3>Quick Quiz: Classify Code</h3>
                                    <p>Pick the Big O for each snippet. Reveal to check.</p>
                                    <ul>
                                        <li>
                                            <pre><code class="language-python">def has_value(arr, x):
    for v in arr:
        if v == x:
            return True
    return False</code></pre>
                                            <details>
                                                <summary>Show answer</summary>
                                                Worst case scans all elements → <strong>O(n)</strong>
                                            </details>
                                        </li>
                                        <li>
                                            <pre><code class="language-python">def pairs(arr):
    n = len(arr)
    for i in range(n):
        for j in range(i):
            _ = arr[i] + arr[j]
                                            </code></pre>
                                            <details>
                                                <summary>Show answer</summary>
                                                Triangular nested loop → about n(n-1)/2 steps → <strong>O(n²)</strong>
                                            </details>
                                        </li>
                                        <li>
                                            <pre><code class="language-python">def shrink(n):
    count = 0
    while n > 1:
        n //= 2
        count += 1
    return count</code></pre>
                                            <details>
                                                <summary>Show answer</summary>
                                                Halving each step → <strong>O(log n)</strong>
                                            </details>
                                        </li>
                                    </ul>

                                    <h3>1. O(1) - Constant Time ⚡</h3>
                                    <p>Operations that take the same time regardless of input size.</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="dsa/complexity-constant.py" />
                                        <jsp:param name="language" value="python" />
                                        <jsp:param name="editorId" value="compiler-constant" />
                                    </jsp:include>

                                    <div class="success-box">
                                        <strong>Examples of O(1):</strong>
                                        <ul>
                                            <li>Array access by index: <code>arr[5]</code></li>
                                            <li>Hash table lookup: <code>dict[key]</code></li>
                                            <li>Push/pop from stack</li>
                                            <li>Simple arithmetic operations</li>
                                        </ul>
                                    </div>

                                    <h3>2. O(log n) - Logarithmic Time 🚀</h3>
                                    <p>Algorithms that halve the problem size each step. Very efficient!</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="dsa/complexity-logarithmic.py" />
                                        <jsp:param name="language" value="python" />
                                        <jsp:param name="editorId" value="compiler-logarithmic" />
                                    </jsp:include>

                                    <div class="success-box">
                                        <strong>Examples of O(log n):</strong>
                                        <ul>
                                            <li>Binary search on sorted array</li>
                                            <li>Balanced binary search tree operations</li>
                                            <li>Finding power of a number (divide and conquer)</li>
                                        </ul>
                                    </div>

                                    <h3>3. O(n) - Linear Time 📈</h3>
                                    <p>Runtime grows proportionally with input size.</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="dsa/complexity-linear.py" />
                                        <jsp:param name="language" value="python" />
                                        <jsp:param name="editorId" value="compiler-linear" />
                                    </jsp:include>

                                    <div class="success-box">
                                        <strong>Examples of O(n):</strong>
                                        <ul>
                                            <li>Linear search through array</li>
                                            <li>Finding min/max in unsorted array</li>
                                            <li>Counting elements</li>
                                            <li>Printing all elements</li>
                                        </ul>
                                    </div>

                                    <h3>4. O(n log n) - Linearithmic Time ⚙️</h3>
                                    <p>Common in efficient sorting algorithms.</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="dsa/complexity-linearithmic.py" />
                                        <jsp:param name="language" value="python" />
                                        <jsp:param name="editorId" value="compiler-linearithmic" />
                                    </jsp:include>

                                    <div class="success-box">
                                        <strong>Examples of O(n log n):</strong>
                                        <ul>
                                            <li>Merge sort</li>
                                            <li>Quick sort (average case)</li>
                                            <li>Heap sort</li>
                                            <li>Sorting is often the bottleneck!</li>
                                        </ul>
                                    </div>

                                    <h3>5. O(n²) - Quadratic Time 🐌</h3>
                                    <p>Nested loops over the input. Gets slow quickly!</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="dsa/complexity-quadratic.py" />
                                        <jsp:param name="language" value="python" />
                                        <jsp:param name="editorId" value="compiler-quadratic" />
                                    </jsp:include>

                                    <div class="warning-box">
                                        <strong>Caution:</strong> O(n²) algorithms are acceptable for small inputs (n <
                                            1000) but become impractical for large datasets. Always look for better
                                            alternatives! </div>

                                            <div class="success-box">
                                                <strong>Examples of O(n²):</strong>
                                                <ul>
                                                    <li>Bubble sort, Selection sort, Insertion sort</li>
                                                    <li>Checking all pairs in an array</li>
                                                    <li>Naive duplicate detection</li>
                                                </ul>
                                            </div>

                                            <h3>6. O(2ⁿ) - Exponential Time 💥</h3>
                                            <p>Doubles with each additional input. Avoid if possible!</p>

                                            <jsp:include page="../tutorial-compiler.jsp">
                                                <jsp:param name="codeFile" value="dsa/complexity-exponential.py" />
                                                <jsp:param name="language" value="python" />
                                                <jsp:param name="editorId" value="compiler-exponential" />
                                            </jsp:include>

                                            <div class="warning-box">
                                                <strong>Warning:</strong> O(2ⁿ) algorithms are only practical for very
                                                small inputs (n < 20). They're often a sign that optimization is needed!
                                                    </div>

                                                    <!-- Comparison Table -->
                                                    <h2>Complexity Comparison Table</h2>

                                                    <p>Here's how different complexities scale with input size:</p>

                                                    <table class="info-table">
                                                        <thead>
                                                            <tr>
                                                                <th>Complexity</th>
                                                                <th>n=10</th>
                                                                <th>n=100</th>
                                                                <th>n=1,000</th>
                                                                <th>n=10,000</th>
                                                            </tr>
                                                        </thead>
                                                        <tbody>
                                                            <tr>
                                                                <td><strong>O(1)</strong></td>
                                                                <td>1</td>
                                                                <td>1</td>
                                                                <td>1</td>
                                                                <td>1</td>
                                                            </tr>
                                                            <tr>
                                                                <td><strong>O(log n)</strong></td>
                                                                <td>3</td>
                                                                <td>7</td>
                                                                <td>10</td>
                                                                <td>13</td>
                                                            </tr>
                                                            <tr>
                                                                <td><strong>O(n)</strong></td>
                                                                <td>10</td>
                                                                <td>100</td>
                                                                <td>1,000</td>
                                                                <td>10,000</td>
                                                            </tr>
                                                            <tr>
                                                                <td><strong>O(n log n)</strong></td>
                                                                <td>30</td>
                                                                <td>664</td>
                                                                <td>9,966</td>
                                                                <td>132,877</td>
                                                            </tr>
                                                            <tr>
                                                                <td><strong>O(n²)</strong></td>
                                                                <td>100</td>
                                                                <td>10,000</td>
                                                                <td>1,000,000</td>
                                                                <td>100,000,000</td>
                                                            </tr>
                                                            <tr>
                                                                <td><strong>O(2ⁿ)</strong></td>
                                                                <td>1,024</td>
                                                                <td>1.27×10³⁰</td>
                                                                <td>∞</td>
                                                                <td>∞</td>
                                                            </tr>
                                                        </tbody>
                                                    </table>

                                                    <div class="tip-box">
                                                        <strong>Key Insight:</strong> Notice how O(2ⁿ) becomes
                                                        impossible even for n=100! This is why algorithm choice is
                                                        critical for scalability.
                                                    </div>

                                                    <!-- Section 4: Space Complexity -->
                                                    <h2>Space Complexity</h2>

                                                    <p>Space complexity measures how much <strong>extra memory</strong>
                                                        an algorithm uses as input size grows. It doesn't count the
                                                        input itself, only additional space needed.</p>

                                                    <h3>O(1) Space - In-Place Algorithms</h3>
                                                    <p>Uses constant extra space regardless of input size:</p>

                                                    <jsp:include page="../tutorial-compiler.jsp">
                                                        <jsp:param name="codeFile"
                                                            value="dsa/complexity-space-inplace.py" />
                                                        <jsp:param name="language" value="python" />
                                                        <jsp:param name="editorId" value="compiler-space-inplace" />
                                                    </jsp:include>

                                                    <h3>O(n) Space - Extra Data Structures</h3>
                                                    <p>Creates new arrays, lists, or hash maps proportional to input:
                                                    </p>

                                                    <jsp:include page="../tutorial-compiler.jsp">
                                                        <jsp:param name="codeFile"
                                                            value="dsa/complexity-space-extra.py" />
                                                        <jsp:param name="language" value="python" />
                                                        <jsp:param name="editorId" value="compiler-space-extra" />
                                                    </jsp:include>

                                                    <div class="info-box">
                                                        <h4>Time vs Space Tradeoff</h4>
                                                        <p>Often you can trade time for space or vice versa:</p>
                                                        <ul>
                                                            <li><strong>Hash tables:</strong> Use O(n) space to get O(1)
                                                                lookup time</li>
                                                            <li><strong>Memoization:</strong> Store results (O(n) space)
                                                                to avoid recomputation</li>
                                                            <li><strong>In-place sorting:</strong> Save space but may be
                                                                slower</li>
                                                        </ul>
                                                    </div>

                                                    <!-- Section 5: How to Calculate Complexity -->
                                                    <h2>How to Calculate Complexity</h2>

                                                    <h3>Rule 1: Drop Constants</h3>
                                                    <pre><code class="language-python"># O(2n) → O(n)
for i in range(n):
    print(i)
for i in range(n):
    print(i)

# Both loops are O(n), total is O(2n) = O(n)</code></pre>

                                                    <h3>Rule 2: Drop Non-Dominant Terms</h3>
                                                    <pre><code class="language-python"># O(n² + n) → O(n²)
for i in range(n):
    for j in range(n):
        print(i, j)  # O(n²)

for i in range(n):
    print(i)  # O(n)

# n² dominates n, so total is O(n²)</code></pre>

                                                    <h3>Rule 3: Different Inputs = Different Variables</h3>
                                                    <pre><code class="language-python"># O(a + b), NOT O(n)
for i in range(len(a)):
    print(a[i])

for j in range(len(b)):
    print(b[j])</code></pre>

                                                    <h3>Rule 4: Nested Loops = Multiply</h3>
                                                    <pre><code class="language-python"># O(n × m)
for i in range(n):
    for j in range(m):
        print(i, j)</code></pre>

                                                    <div class="tip-box">
                                                        <strong>Quick Reference:</strong>
                                                        <ul>
                                                            <li>Single loop → O(n)</li>
                                                            <li>Nested loops → O(n²), O(n³), etc.</li>
                                                            <li>Halving input → O(log n)</li>
                                                            <li>Recursion → Draw recursion tree</li>
                                                        </ul>
                                                    </div>

                                                    <!-- Common Mistakes -->
                                                    <h2>Common Mistakes</h2>

                                                    <div class="mistake-box">
                                                        <h4>❌ Mistake 1: Confusing O(n) with O(2n)</h4>
                                                        <pre><code class="language-python"># Wrong: "This is O(2n)"
for i in range(n):
    print(i)
for i in range(n):
    print(i)

# Correct: O(2n) = O(n)
# Constants are dropped in Big O!</code></pre>
                                                    </div>

                                                    <div class="mistake-box">
                                                        <h4>❌ Mistake 2: Ignoring Best/Average/Worst Cases</h4>
                                                        <pre><code class="language-python"># Quick Sort:
# Best case: O(n log n)
# Average case: O(n log n)
# Worst case: O(n²)  ← Big O refers to worst case!

# Always specify which case you're analyzing</code></pre>
                                                    </div>

                                                    <div class="mistake-box">
                                                        <h4>❌ Mistake 3: Forgetting Space Complexity</h4>
                                                        <pre><code class="language-python"># This is O(n) time AND O(n) space!
def create_copy(arr):
    new_arr = []
    for item in arr:
        new_arr.append(item)
    return new_arr

# Always consider both time AND space!</code></pre>
                                                    </div>

                                                    <!-- Exercise -->
                                                    <h2>Exercise: Analyze Complexity</h2>
                                                    <div class="exercise-section">
                                                        <p><strong>Task:</strong> Determine the time complexity of each
                                                            function below.</p>

                                                        <jsp:include page="../tutorial-compiler.jsp">
                                                            <jsp:param name="codeFile"
                                                                value="dsa/exercises/ex-complexity.py" />
                                                            <jsp:param name="language" value="python" />
                                                            <jsp:param name="editorId" value="exercise-complexity" />
                                                        </jsp:include>

                                                        <details class="exercise-hint">
                                                            <summary>💡 Show Solutions</summary>
                                                            <ul>
                                                                <li><strong>Function 1:</strong> O(1) - Just two array
                                                                    accesses, constant time</li>
                                                                <li><strong>Function 2:</strong> O(n) - Single loop
                                                                    through all elements</li>
                                                                <li><strong>Function 3:</strong> O(n²) - Nested loops,
                                                                    both iterate n times</li>
                                                                <li><strong>Function 4:</strong> O(log n) - Binary
                                                                    search, halves search space</li>
                                                                <li><strong>Function 5:</strong> O(2ⁿ) - Naive
                                                                    Fibonacci, exponential recursion</li>
                                                            </ul>
                                                        </details>
                                                    </div>

                                                    <!-- Summary -->
                                                    <h2>Summary</h2>
                                                    <div class="summary-box">
                                                        <ul>
                                                            <li><strong>Big O Notation:</strong> Describes worst-case
                                                                growth rate of algorithms</li>
                                                            <li><strong>Common Classes:</strong> O(1), O(log n), O(n),
                                                                O(n log n), O(n²), O(2ⁿ)</li>
                                                            <li><strong>Drop Constants:</strong> O(2n) = O(n), O(n + 5)
                                                                = O(n)</li>
                                                            <li><strong>Dominant Terms:</strong> O(n² + n) = O(n²)</li>
                                                            <li><strong>Space Complexity:</strong> Measure extra memory
                                                                used</li>
                                                            <li><strong>Tradeoffs:</strong> Often can trade time for
                                                                space or vice versa</li>
                                                            <li><strong>Analysis Rules:</strong> Loops multiply,
                                                                sequential operations add</li>
                                                        </ul>
                                                        <p><strong>Bring it back to reality:</strong> If users double
                                                            and
                                                            your endpoint slows, Big O helps you reason about where the
                                                            time goes — aim for <strong>O(n log n)</strong> solutions
                                                            over <strong>O(n²)</strong> when scaling. In interviews,
                                                            explain the tradeoffs clearly.</p>
                                                    </div>

                                                    <h2>What's Next?</h2>
                                                    <p>Now that you understand how to analyze algorithm efficiency,
                                                        you're ready to dive into actual algorithms! In the next lesson,
                                                        we'll explore <strong>Algorithm Analysis Techniques</strong>
                                                        including recurrence relations and the Master Theorem for
                                                        analyzing recursive algorithms.</p>

                                                    <div class="tip-box">
                                                        <strong>Practice Tip:</strong> For every algorithm you learn
                                                        from now on, always ask: "What's the time complexity? What's the
                                                        space complexity?" This habit will make you a better programmer!
                                                    </div>
                                            </div>

                                            <jsp:include page="../tutorial-ad-slot.jsp">
                                                <jsp:param name="slot" value="bottom" />
                                            </jsp:include>

                                            <jsp:include page="../tutorial-nav.jsp">
                                                <jsp:param name="prevLink" value="intro.jsp" />
                                                <jsp:param name="prevTitle" value="Why DSA Matters" />
                                                <jsp:param name="nextLink" value="algorithm-analysis.jsp" />
                                                <jsp:param name="nextTitle" value="Algorithm Analysis" />
                                                <jsp:param name="currentLessonId" value="complexity" />
                                            </jsp:include>
                            </article>
                    </main>

                    <%@ include file="../tutorial-footer.jsp" %>
            </div>

            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/python.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/progress.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/tutorial-core.js?v=4"></script>
            <script src="<%=request.getContextPath()%>/tutorials/dsa/visualizations/bigo-complexity-viz.js"></script>
        </body>

        </html>