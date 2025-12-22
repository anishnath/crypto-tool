<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "algorithm-analysis" );
        request.setAttribute("currentModule", "Introduction & Fundamentals" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Analyzing Recursive Algorithms - DSA Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Learn how to analyze recursive algorithms like merge sort and binary search. Understand recurrence relations and the Master Theorem with visual examples.">
            <meta name="keywords"
                content="recursive algorithms, merge sort analysis, binary search, recurrence relations, master theorem, algorithm analysis">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Analyzing Recursive Algorithms - DSA Tutorial">
            <meta property="og:description"
                content="Visual guide to analyzing recursive algorithms with recurrence relations and Master Theorem.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/dsa/algorithm-analysis.jsp">
            <link rel="icon" type="image/svg+xml"
                href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial-server.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror.min.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/monokai.min.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/dsa/styles/visualization.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/dsa/styles/recursion-viz.css">

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
        "name": "Analyzing Recursive Algorithms",
        "description": "Learn to analyze recursive algorithms using visual recursion trees and the Master Theorem.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Beginner to Intermediate",
        "teaches": ["Recursive Algorithm Analysis", "Recurrence Relations", "Master Theorem", "Divide and Conquer"],
        "timeRequired": "PT20M",
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

        <body class="tutorial-body no-preview" data-lesson="algorithm-analysis">
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
                                    <span>Analyzing Recursive Algorithms</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">🔬 Analyzing Recursive Algorithms</h1>
                                    <div class="lesson-meta">
                                        <span>Beginner Friendly</span>
                                        <span>~20 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">You know merge sort is fast - but exactly HOW fast? In this lesson,
                                        you'll learn a simple visual method to analyze recursive algorithms, plus a
                                        powerful shortcut called the Master Theorem that works like magic!</p>
                                    <p>This builds on your complexity intuition from the previous lesson.</p>

                                    <!-- Story Section -->
                                    <div class="success-box" style="margin: var(--space-8) 0;">
                                        <h3 style="margin-top: 0;">💼 The Google Interview Question</h3>
                                        <p><strong>Interviewer:</strong> "Explain why merge sort is O(n log n)."</p>

                                        <p><strong>Candidate A:</strong> "Um... because it's a divide-and-conquer
                                            algorithm?" ❌<br>
                                            <em>Result: Rejected. No proof.</em>
                                        </p>

                                        <p><strong>Candidate B:</strong> "Let me draw the recursion tree..." ✅<br>
                                            <em>Draws tree, counts levels, shows work at each level.</em><br>
                                            <strong>Interviewer:</strong> "Perfect! When can you start?"
                                        </p>

                                        <p style="margin-bottom: 0;"><strong>The difference?</strong> Candidate B could
                                            <em>prove</em> it, not just memorize it.</p>
                                    </div>

                                    <!-- Recursion Tree SVG -->
                                    <div
                                        style="background: var(--bg-secondary); border-radius: var(--radius-lg); padding: var(--space-6); margin: var(--space-8) 0;">
                                        <h3 style="text-align: center; margin-top: 0;">Merge Sort Recursion Tree (n=8)
                                        </h3>
                                        <svg viewBox="0 0 800 450"
                                            style="width: 100%; max-width: 800px; height: auto; display: block; margin: 0 auto;">
                                            <!-- Level 0 -->
                                            <rect x="350" y="20" width="100" height="50" fill="#4dabf7" opacity="0.3"
                                                stroke="#4dabf7" stroke-width="2" rx="5" />
                                            <text x="400" y="40" text-anchor="middle" fill="var(--text-primary)"
                                                font-size="14" font-weight="600">n = 8</text>
                                            <text x="400" y="58" text-anchor="middle" fill="var(--text-secondary)"
                                                font-size="11">Work: O(n)</text>

                                            <!-- Level 0 label -->
                                            <text x="50" y="45" fill="var(--text-primary)" font-size="13"
                                                font-weight="600">Level 0:</text>
                                            <text x="750" y="45" fill="#4dabf7" font-size="12" font-weight="600">1 × n =
                                                n</text>

                                            <!-- Lines to Level 1 -->
                                            <line x1="380" y1="70" x2="250" y2="110" stroke="var(--border)"
                                                stroke-width="2" />
                                            <line x1="420" y1="70" x2="550" y2="110" stroke="var(--border)"
                                                stroke-width="2" />

                                            <!-- Level 1 -->
                                            <rect x="200" y="120" width="100" height="50" fill="#51cf66" opacity="0.3"
                                                stroke="#51cf66" stroke-width="2" rx="5" />
                                            <text x="250" y="140" text-anchor="middle" fill="var(--text-primary)"
                                                font-size="14" font-weight="600">n/2 = 4</text>
                                            <text x="250" y="158" text-anchor="middle" fill="var(--text-secondary)"
                                                font-size="11">Work: O(n/2)</text>

                                            <rect x="500" y="120" width="100" height="50" fill="#51cf66" opacity="0.3"
                                                stroke="#51cf66" stroke-width="2" rx="5" />
                                            <text x="550" y="140" text-anchor="middle" fill="var(--text-primary)"
                                                font-size="14" font-weight="600">n/2 = 4</text>
                                            <text x="550" y="158" text-anchor="middle" fill="var(--text-secondary)"
                                                font-size="11">Work: O(n/2)</text>

                                            <!-- Level 1 label -->
                                            <text x="50" y="145" fill="var(--text-primary)" font-size="13"
                                                font-weight="600">Level 1:</text>
                                            <text x="750" y="145" fill="#51cf66" font-size="12" font-weight="600">2 ×
                                                n/2 = n</text>

                                            <!-- Lines to Level 2 -->
                                            <line x1="230" y1="170" x2="175" y2="210" stroke="var(--border)"
                                                stroke-width="2" />
                                            <line x1="270" y1="170" x2="325" y2="210" stroke="var(--border)"
                                                stroke-width="2" />
                                            <line x1="530" y1="170" x2="475" y2="210" stroke="var(--border)"
                                                stroke-width="2" />
                                            <line x1="570" y1="170" x2="625" y2="210" stroke="var(--border)"
                                                stroke-width="2" />

                                            <!-- Level 2 -->
                                            <rect x="125" y="220" width="100" height="50" fill="#ff9800" opacity="0.3"
                                                stroke="#ff9800" stroke-width="2" rx="5" />
                                            <text x="175" y="240" text-anchor="middle" fill="var(--text-primary)"
                                                font-size="14" font-weight="600">n/4 = 2</text>
                                            <text x="175" y="258" text-anchor="middle" fill="var(--text-secondary)"
                                                font-size="11">O(n/4)</text>

                                            <rect x="275" y="220" width="100" height="50" fill="#ff9800" opacity="0.3"
                                                stroke="#ff9800" stroke-width="2" rx="5" />
                                            <text x="325" y="240" text-anchor="middle" fill="var(--text-primary)"
                                                font-size="14" font-weight="600">n/4 = 2</text>
                                            <text x="325" y="258" text-anchor="middle" fill="var(--text-secondary)"
                                                font-size="11">O(n/4)</text>

                                            <rect x="425" y="220" width="100" height="50" fill="#ff9800" opacity="0.3"
                                                stroke="#ff9800" stroke-width="2" rx="5" />
                                            <text x="475" y="240" text-anchor="middle" fill="var(--text-primary)"
                                                font-size="14" font-weight="600">n/4 = 2</text>
                                            <text x="475" y="258" text-anchor="middle" fill="var(--text-secondary)"
                                                font-size="11">O(n/4)</text>

                                            <rect x="575" y="220" width="100" height="50" fill="#ff9800" opacity="0.3"
                                                stroke="#ff9800" stroke-width="2" rx="5" />
                                            <text x="625" y="240" text-anchor="middle" fill="var(--text-primary)"
                                                font-size="14" font-weight="600">n/4 = 2</text>
                                            <text x="625" y="258" text-anchor="middle" fill="var(--text-secondary)"
                                                font-size="11">O(n/4)</text>

                                            <!-- Level 2 label -->
                                            <text x="50" y="245" fill="var(--text-primary)" font-size="13"
                                                font-weight="600">Level 2:</text>
                                            <text x="750" y="245" fill="#ff9800" font-size="12" font-weight="600">4 ×
                                                n/4 = n</text>

                                            <!-- Dots for more levels -->
                                            <text x="400" y="300" text-anchor="middle" fill="var(--text-muted)"
                                                font-size="20">⋮</text>

                                            <!-- Level 3 (base case) -->
                                            <circle cx="100" cy="350" r="20" fill="#e91e63" opacity="0.3"
                                                stroke="#e91e63" stroke-width="2" />
                                            <text x="100" y="355" text-anchor="middle" fill="var(--text-primary)"
                                                font-size="12" font-weight="600">1</text>

                                            <circle cx="200" cy="350" r="20" fill="#e91e63" opacity="0.3"
                                                stroke="#e91e63" stroke-width="2" />
                                            <text x="200" y="355" text-anchor="middle" fill="var(--text-primary)"
                                                font-size="12" font-weight="600">1</text>

                                            <circle cx="300" cy="350" r="20" fill="#e91e63" opacity="0.3"
                                                stroke="#e91e63" stroke-width="2" />
                                            <text x="300" y="355" text-anchor="middle" fill="var(--text-primary)"
                                                font-size="12" font-weight="600">1</text>

                                            <text x="400" y="355" text-anchor="middle" fill="var(--text-muted)"
                                                font-size="16">...</text>

                                            <circle x="600" cy="350" r="20" fill="#e91e63" opacity="0.3"
                                                stroke="#e91e63" stroke-width="2" />
                                            <text x="600" y="355" text-anchor="middle" fill="var(--text-primary)"
                                                font-size="12" font-weight="600">1</text>

                                            <circle cx="700" cy="350" r="20" fill="#e91e63" opacity="0.3"
                                                stroke="#e91e63" stroke-width="2" />
                                            <text x="700" y="355" text-anchor="middle" fill="var(--text-primary)"
                                                font-size="12" font-weight="600">1</text>

                                            <!-- Level 3 label -->
                                            <text x="50" y="355" fill="var(--text-primary)" font-size="13"
                                                font-weight="600">Level log n:</text>
                                            <text x="750" y="355" fill="#e91e63" font-size="12" font-weight="600">n × 1
                                                = n</text>

                                            <!-- Summary box -->
                                            <rect x="150" y="390" width="500" height="50" fill="var(--accent-primary)"
                                                opacity="0.1" stroke="var(--accent-primary)" stroke-width="2" rx="8" />
                                            <text x="400" y="410" text-anchor="middle" fill="var(--text-primary)"
                                                font-size="15" font-weight="700">
                                                Total: log n levels × n work per level = O(n log n)
                                            </text>
                                            <text x="400" y="428" text-anchor="middle" fill="var(--accent-primary)"
                                                font-size="13" font-weight="600">
                                                ✅ This is why merge sort is O(n log n)!
                                            </text>
                                        </svg>

                                        <div
                                            style="margin-top: var(--space-6); display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: var(--space-4);">
                                            <div
                                                style="padding: var(--space-3); background: rgba(77, 171, 247, 0.1); border-left: 4px solid #4dabf7; border-radius: var(--radius-md);">
                                                <strong style="color: #4dabf7;">📊 Pattern</strong>
                                                <p
                                                    style="margin: var(--space-1) 0 0; font-size: var(--text-sm); color: var(--text-secondary);">
                                                    Every level does <strong>n</strong> work total
                                                </p>
                                            </div>
                                            <div
                                                style="padding: var(--space-3); background: rgba(81, 207, 102, 0.1); border-left: 4px solid #51cf66; border-radius: var(--radius-md);">
                                                <strong style="color: #51cf66;">📏 Depth</strong>
                                                <p
                                                    style="margin: var(--space-1) 0 0; font-size: var(--text-sm); color: var(--text-secondary);">
                                                    Tree has <strong>log n</strong> levels
                                                </p>
                                            </div>
                                            <div
                                                style="padding: var(--space-3); background: rgba(255, 152, 0, 0.1); border-left: 4px solid #ff9800; border-radius: var(--radius-md);">
                                                <strong style="color: #ff9800;">🎯 Result</strong>
                                                <p
                                                    style="margin: var(--space-1) 0 0; font-size: var(--text-sm); color: var(--text-secondary);">
                                                    <strong>n × log n = O(n log n)</strong>
                                                </p>
                                            </div>
                                        </div>

                                        <p
                                            style="text-align: center; color: var(--text-secondary); margin-top: var(--space-4); margin-bottom: 0;">
                                            <strong>The recursion tree method:</strong> Draw it, count the levels, sum
                                            the work. That's it!
                                        </p>
                                    </div>

                                    <!-- Section 1: The Problem -->
                                    <h2>The Challenge: Analyzing Merge Sort</h2>

                                    <p>Let's say you're in a job interview and someone asks: <strong>"What's the time
                                            complexity of merge sort?"</strong></p>

                                    <p>You might say "O(n log n)" - but then they ask: <strong>"How do you KNOW
                                            that?"</strong></p>

                                    <div class="info-box">
                                        <h4>🤔 The Problem</h4>
                                        <p>With loops, you can count iterations. But merge sort calls itself recursively
                                            - how do you count that?</p>
                                        <pre><code class="language-python">def merge_sort(arr):
    if len(arr) <= 1:
        return arr
    
    mid = len(arr) // 2
    left = merge_sort(arr[:mid])    # ← Recursive call
    right = merge_sort(arr[mid:])   # ← Recursive call
    return merge(left, right)       # ← Some work here</code></pre>
                                        <p><strong>Question:</strong> How many operations does this do for an array of
                                            size n?</p>
                                    </div>

                                    <h2>Step 1: Draw the Recursion Tree</h2>

                                    <p>The best way to understand recursive algorithms is to <strong>draw how they break
                                            down the problem</strong>. Watch this visualization:</p>

                                    <div class="visualization-container">
                                        <div id="recursionTreeViz"></div>
                                    </div>

                                    <div class="success-box">
                                        <h4>💡 What You're Seeing</h4>
                                        <p>Merge sort breaks the problem into smaller pieces:</p>
                                        <ul>
                                            <li><strong>Level 0:</strong> Sort array of size n</li>
                                            <li><strong>Level 1:</strong> Sort 2 arrays of size n/2</li>
                                            <li><strong>Level 2:</strong> Sort 4 arrays of size n/4</li>
                                            <li><strong>Level 3:</strong> Sort 8 arrays of size n/8</li>
                                            <li>...and so on until arrays are size 1</li>
                                        </ul>
                                    </div>

                                    <h3>Counting Operations by Hand</h3>

                                    <p>Let's count the work at each level for an array of size 8:</p>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Level</th>
                                                <th>Number of Arrays</th>
                                                <th>Size of Each</th>
                                                <th>Work Per Array</th>
                                                <th>Total Work</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>0</td>
                                                <td>1</td>
                                                <td>8</td>
                                                <td>8</td>
                                                <td><strong>8</strong></td>
                                            </tr>
                                            <tr>
                                                <td>1</td>
                                                <td>2</td>
                                                <td>4</td>
                                                <td>4</td>
                                                <td><strong>8</strong></td>
                                            </tr>
                                            <tr>
                                                <td>2</td>
                                                <td>4</td>
                                                <td>2</td>
                                                <td>2</td>
                                                <td><strong>8</strong></td>
                                            </tr>
                                            <tr>
                                                <td>3</td>
                                                <td>8</td>
                                                <td>1</td>
                                                <td>1</td>
                                                <td><strong>8</strong></td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <div class="tip-box">
                                        <strong>Pattern Discovered!</strong> Each level does exactly <strong>n</strong>
                                        work (8 in this case).
                                        <br>How many levels? <strong>log₂(n)</strong> levels (because you keep dividing
                                        by 2).
                                        <br><strong>Total work = n × log n = O(n log n)</strong> ✅
                                    </div>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <!-- Section 2: Writing It Down -->
                                    <h2>Step 2: Writing the Pattern (Recurrence Relation)</h2>

                                    <p>Instead of drawing trees every time, you can write this pattern as a formula:</p>

                                    <div class="info-box">
                                        <h4>For Merge Sort:</h4>
                                        <p
                                            style="text-align: center; font-size: 1.3rem; font-family: 'Fira Code', monospace; color: #3b82f6; margin: 1rem 0;">
                                            <strong>T(n) = 2 × T(n/2) + n</strong>
                                        </p>
                                        <p><strong>Translation:</strong></p>
                                        <ul>
                                            <li><code>T(n)</code> = Time to sort n elements</li>
                                            <li><code>2 × T(n/2)</code> = Sort two halves (each of size n/2)</li>
                                            <li><code>+ n</code> = Merge the halves back together (n operations)</li>
                                        </ul>
                                    </div>

                                    <p>This is called a <strong>recurrence relation</strong> - it's just a way to write
                                        "the time for n depends on the time for smaller problems."</p>

                                    <h3>Example: Binary Search</h3>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="dsa/analysis-binarysearch.py" />
                                        <jsp:param name="language" value="python" />
                                        <jsp:param name="editorId" value="compiler-binarysearch" />
                                    </jsp:include>

                                    <div class="success-box">
                                        <h4>Binary Search Pattern:</h4>
                                        <p
                                            style="font-family: 'Fira Code', monospace; color: #3b82f6; font-size: 1.1rem;">
                                            <strong>T(n) = T(n/2) + 1</strong>
                                        </p>
                                        <ul>
                                            <li><code>T(n/2)</code> = Search one half</li>
                                            <li><code>+ 1</code> = Compare middle element (constant work)</li>
                                            <li><strong>Result:</strong> O(log n) - very fast!</li>
                                        </ul>
                                    </div>

                                    <!-- Section 3: The Master Theorem Shortcut -->
                                    <h2>Step 3: The Master Theorem (The Shortcut!)</h2>

                                    <p>Drawing trees is great for understanding, but there's a faster way! The
                                        <strong>Master Theorem</strong> is like a calculator for these patterns.
                                    </p>

                                    <div class="info-box">
                                        <h4>The Master Theorem - Simple Version</h4>
                                        <p>For patterns like: <strong>T(n) = a × T(n/b) + work</strong></p>
                                        <p><strong>Ask one question:</strong> "Which part dominates - the recursion or
                                            the work?"</p>
                                    </div>

                                    <h3>The Three Cases (Simplified)</h3>

                                    <div class="success-box">
                                        <h4>Case 1: Recursion Dominates</h4>
                                        <p><strong>When:</strong> You split into MANY subproblems (a is large)</p>
                                        <p><strong>Example:</strong> T(n) = 4T(n/2) + n</p>
                                        <p><strong>Result:</strong> The splitting dominates → O(n²)</p>
                                    </div>

                                    <div class="success-box">
                                        <h4>Case 2: Balanced (Most Common!)</h4>
                                        <p><strong>When:</strong> Recursion and work are balanced</p>
                                        <p><strong>Examples:</strong></p>
                                        <ul>
                                            <li>Merge Sort: T(n) = 2T(n/2) + n → O(n log n)</li>
                                            <li>Binary Search: T(n) = T(n/2) + 1 → O(log n)</li>
                                        </ul>
                                        <p><strong>Result:</strong> Add a log factor → O(work × log n)</p>
                                    </div>

                                    <div class="success-box">
                                        <h4>Case 3: Work Dominates</h4>
                                        <p><strong>When:</strong> You do a LOT of work at each level</p>
                                        <p><strong>Example:</strong> T(n) = 2T(n/2) + n²</p>
                                        <p><strong>Result:</strong> The work dominates → O(n²)</p>
                                    </div>

                                    <h3>Try It Yourself!</h3>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="dsa/analysis-master-theorem.py" />
                                        <jsp:param name="language" value="python" />
                                        <jsp:param name="editorId" value="compiler-master" />
                                    </jsp:include>

                                    <h3>Quick Quiz: Classify These</h3>
                                    <p>Use the three cases to identify the complexity and why.</p>
                                    <ul>
                                        <li>
                                            <code>T(n) = 3T(n/3) + n</code>
                                            <details>
                                                <summary>Show answer</summary>
                                                Balanced: <strong>O(n log n)</strong> because
                                                <code>n^{log_3 3} = n</code> and the extra work matches → add a log
                                                factor.
                                            </details>
                                        </li>
                                        <li>
                                            <code>T(n) = 4T(n/2) + n</code>
                                            <details>
                                                <summary>Show answer</summary>
                                                Recursion dominates: <strong>O(n²)</strong> since
                                                <code>n^{log_2 4} = n^2</code> and <code>n</code> is smaller → total is
                                                <code>Θ(n^2)</code>.
                                            </details>
                                        </li>
                                        <li>
                                            <code>T(n) = T(n/2) + log n</code>
                                            <details>
                                                <summary>Show answer</summary>
                                                Slightly more than constant extra work per level → <strong>O((log
                                                    n)^2)</strong> using the extended Master Theorem intuition.
                                            </details>
                                        </li>
                                    </ul>

                                    <!-- Section 4: Common Examples -->
                                    <h2>Common Algorithms</h2>

                                    <p>Here are the patterns you'll see most often:</p>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Algorithm</th>
                                                <th>Pattern</th>
                                                <th>Complexity</th>
                                                <th>Why?</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><strong>Binary Search</strong></td>
                                                <td>T(n) = T(n/2) + 1</td>
                                                <td>O(log n)</td>
                                                <td>Search one half, constant work</td>
                                            </tr>
                                            <tr>
                                                <td><strong>Merge Sort</strong></td>
                                                <td>T(n) = 2T(n/2) + n</td>
                                                <td>O(n log n)</td>
                                                <td>Sort both halves, merge takes n</td>
                                            </tr>
                                            <tr>
                                                <td><strong>Quick Sort (avg)</strong></td>
                                                <td>T(n) = 2T(n/2) + n</td>
                                                <td>O(n log n)</td>
                                                <td>Same as merge sort on average</td>
                                            </tr>
                                            <tr>
                                                <td><strong>Tree Traversal</strong></td>
                                                <td>T(n) = 2T(n/2) + 1</td>
                                                <td>O(n)</td>
                                                <td>Visit every node once</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <h3>See Merge Sort in Action</h3>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="dsa/analysis-mergesort.py" />
                                        <jsp:param name="language" value="python" />
                                        <jsp:param name="editorId" value="compiler-mergesort" />
                                    </jsp:include>

                                    <!-- Section 5: When It Doesn't Work -->
                                    <h2>When Master Theorem Doesn't Work</h2>

                                    <div class="warning-box">
                                        <strong>Important:</strong> Master Theorem only works when you divide by a
                                        constant (like n/2, n/3).
                                    </div>

                                    <div class="mistake-box">
                                        <h4>❌ Fibonacci: T(n) = T(n-1) + T(n-2)</h4>
                                        <p><strong>Why it doesn't work:</strong> Subtracting 1, not dividing by 2</p>
                                        <p><strong>What to do:</strong> Draw the tree - you'll see it's O(2ⁿ) -
                                            exponential!</p>
                                    </div>

                                    <div class="tip-box">
                                        <strong>Pro Tip:</strong> When Master Theorem doesn't apply, draw the recursion
                                        tree and count levels manually. It always works!
                                    </div>

                                    <!-- Summary -->
                                    <h2>Summary: The 3-Step Method</h2>
                                    <div class="summary-box">
                                        <h3>To Analyze Any Recursive Algorithm:</h3>
                                        <ol style="font-size: 1.05rem; line-height: 1.8;">
                                            <li><strong>Draw the recursion tree</strong> - Visualize how it breaks down
                                            </li>
                                            <li><strong>Count work per level</strong> - Usually it's the same at each
                                                level</li>
                                            <li><strong>Apply Master Theorem</strong> - Or count levels if it doesn't
                                                apply</li>
                                        </ol>
                                        <p><strong>Interview ready:</strong> If someone asks "How do you know?" you can
                                            show the recursion tree or write the recurrence to justify it.</p>
                                        <p style="margin-top: 1.5rem;"><strong>Most Common Results:</strong></p>
                                        <ul>
                                            <li>Binary Search: O(log n) - super fast!</li>
                                            <li>Merge Sort: O(n log n) - efficient sorting</li>
                                            <li>Tree Traversal: O(n) - visit each node once</li>
                                        </ul>
                                    </div>

                                    <h2>What's Next?</h2>
                                    <p>🎉 <strong>Congratulations!</strong> You've completed Module 1: Introduction &
                                        Fundamentals!</p>

                                    <div class="success-box">
                                        <h4>You Now Know:</h4>
                                        <ul>
                                            <li>✅ Why DSA matters for your career</li>
                                            <li>✅ Big O notation and complexity analysis</li>
                                            <li>✅ How to analyze recursive algorithms</li>
                                        </ul>
                                        <p style="margin-top: 1rem;"><strong>You're ready for practical
                                                algorithms!</strong></p>
                                    </div>

                                    <p>Next up: <strong>Module 2: Arrays & Strings</strong> where you'll learn powerful
                                        techniques like two pointers, sliding window, and solve real interview problems!
                                    </p>

                                    <div class="tip-box">
                                        <strong>Practice Tip:</strong> Next time you see a recursive algorithm, try
                                        drawing its tree. You'll be amazed how much clearer it becomes!
                                    </div>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="complexity.jsp" />
                                    <jsp:param name="prevTitle" value="Time & Space Complexity" />
                                    <jsp:param name="nextLink" value="array-basics.jsp" />
                                    <jsp:param name="nextTitle" value="Array Fundamentals" />
                                    <jsp:param name="currentLessonId" value="algorithm-analysis" />
                                </jsp:include>
                            </article>
                    </main>

                    <%@ include file="../tutorial-footer.jsp" %>
            </div>

            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/python.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/progress.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/tutorial-core.js?v=4"></script>
            <script src="<%=request.getContextPath()%>/tutorials/dsa/visualizations/recursion-tree-viz.js"></script>
        </body>

        </html>