<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "radix-sort" ); request.setAttribute("currentModule", "Sorting Algorithms"
        ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Radix Sort - DSA Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Learn Radix Sort - extend Counting Sort to larger ranges with O(d×n) digit-by-digit sorting!">
            <meta name="keywords" content="radix sort, LSD, MSD, O(d×n), digit sort, DSA">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Radix Sort - DSA Tutorial">
            <meta property="og:description"
                content="Master Radix Sort - digit-by-digit sorting with linear time for fixed-length keys.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/dsa/radix-sort.jsp">
            <link rel="icon" type="image/svg+xml"
                href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial-server.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror.min.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/monokai.min.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/dsa/styles/visualization.css">

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
        "name": "Radix Sort Algorithm",
        "description": "Learn Radix Sort with digit-by-digit sorting and O(d×n) complexity for fixed-length keys.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Intermediate",
        "teaches": ["Radix Sort", "LSD", "MSD", "O(d×n)", "Digit Sorting"],
        "timeRequired": "PT12M",
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

        <body class="tutorial-body no-preview" data-lesson="radix-sort">
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
                                    <span>Radix Sort</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">🃏 Radix Sort</h1>
                                    <div class="lesson-meta">
                                        <span>Intermediate</span>
                                        <span>~12 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">You have a deck of playing cards to sort. Instead of comparing every
                                        card, you have a <strong>clever strategy</strong>: Sort by suit first, then by
                                        rank. Or for numbers: Sort by ones digit, then tens, then hundreds. Each pass
                                        uses <strong>Counting Sort</strong>. That's Radix Sort - extending Counting Sort
                                        to larger ranges!</p>

                                    <!-- Section 1: The Card Sorter -->
                                    <h2>The Card Sorter</h2>

                                    <p>Imagine a machine with 10 buckets (0-9). Feed numbers through once for each digit
                                        position:</p>

                                    <div class="info-box">
                                        <h4>The Strategy (LSD - Least Significant Digit)</h4>
                                        <ol>
                                            <li><strong>Pass 1:</strong> Sort by ones digit (rightmost) using Counting
                                                Sort</li>
                                            <li><strong>Pass 2:</strong> Sort by tens digit using Counting Sort</li>
                                            <li><strong>Pass 3:</strong> Sort by hundreds digit using Counting Sort</li>
                                            <li><strong>Continue:</strong> Until all digits processed</li>
                                            <li><strong>Result:</strong> Fully sorted!</li>
                                        </ol>
                                        <p><strong>Key insight:</strong> Each digit has small range (0-9), perfect for
                                            Counting Sort!</p>
                                    </div>

                                    <h3>Extending Counting Sort</h3>

                                    <div class="success-box">
                                        <h4>The Breakthrough</h4>
                                        <p><strong>Counting Sort limitation:</strong> Only works for small ranges (like
                                            0-100)</p>
                                        <p><strong>Radix Sort solution:</strong> Sort digit-by-digit!</p>
                                        <ul>
                                            <li><strong>Each digit:</strong> Small range (0-9) ✓</li>
                                            <li><strong>Multiple passes:</strong> d passes for d digits</li>
                                            <li><strong>Total time:</strong> O(d × n) - linear for fixed d!</li>
                                            <li><strong>Uses:</strong> Stable Counting Sort for each digit</li>
                                        </ul>
                                    </div>

                                    <!-- Visualization -->
                                    <h3>See It in Action</h3>
                                    <p>Watch how Radix Sort processes each digit position:</p>

                                    <div id="radixSortVisualization"></div>

                                    <div class="info-box">
                                        <h4>Understanding the Process</h4>
                                        <ul>
                                            <li><strong>Pass 1 (ones):</strong> Sort by rightmost digit</li>
                                            <li><strong>Pass 2 (tens):</strong> Sort by second digit (stable!)</li>
                                            <li><strong>Pass 3 (hundreds):</strong> Sort by third digit (stable!)</li>
                                            <li><strong>Each pass:</strong> O(n + k) where k=10</li>
                                            <li><strong>Total:</strong> O(d × n) for d digits</li>
                                            <li><strong>Stability crucial:</strong> Preserves previous sorting!</li>
                                        </ul>
                                    </div>

                                    <!-- Code Example -->
                                    <h3>The Code</h3>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="dsa/radix-sort-basic.py" />
                                        <jsp:param name="language" value="python" />
                                        <jsp:param name="editorId" value="compiler-radix-basic" />
                                    </jsp:include>

                                    <div class="tip-box">
                                        <strong>Why Stability Matters:</strong> Without stable sorting, each pass would
                                        destroy the work of previous passes! After sorting by ones digit, numbers with
                                        the same tens digit must stay in order by ones digit. That's why we use stable
                                        Counting Sort!
                                    </div>

                                    <!-- Quick Quiz -->
                                    <h3>Quick Quiz</h3>
                                    <ul>
                                        <li>
                                            <strong>Why does LSD Radix Sort start from the rightmost digit?</strong>
                                            <details>
                                                <summary>Show answer</summary>
                                                Because of stability! After sorting by ones digit, all numbers ending in
                                                0 are together, all ending in 1 are together, etc. When we sort by tens
                                                digit (stably!), numbers with the same tens digit stay in order by ones
                                                digit. This builds up the final sorted order digit by digit. Starting
                                                from the left (MSD) would require more complex recursive logic!
                                            </details>
                                        </li>
                                        <li>
                                            <strong>When would Radix Sort be slower than Quick Sort?</strong>
                                            <details>
                                                <summary>Show answer</summary>
                                                When d (number of digits) is large! If sorting 64-bit integers (d=20
                                                digits), Radix Sort is O(20n). Quick Sort is O(n log n) ≈ O(20n) for
                                                n=1M. They're comparable! But for variable-length or very large d, Quick
                                                Sort wins. Radix Sort is best for fixed-length keys with small d!
                                            </details>
                                        </li>
                                    </ul>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <!-- Complexity Analysis -->
                                    <h2>Why O(d × n)?</h2>

                                    <p>Let's break down the complexity:</p>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Step</th>
                                                <th>Time</th>
                                                <th>Why</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>Find max (get d)</td>
                                                <td>O(n)</td>
                                                <td>One scan to find number of digits</td>
                                            </tr>
                                            <tr>
                                                <td>Each pass</td>
                                                <td>O(n + k)</td>
                                                <td>Counting Sort for one digit (k=10)</td>
                                            </tr>
                                            <tr>
                                                <td>Number of passes</td>
                                                <td>d</td>
                                                <td>One per digit position</td>
                                            </tr>
                                            <tr>
                                                <td><strong>Total</strong></td>
                                                <td><strong>O(d × (n + k))</strong></td>
                                                <td>d passes × O(n + 10) each</td>
                                            </tr>
                                            <tr>
                                                <td><strong>Simplified</strong></td>
                                                <td><strong>O(d × n)</strong></td>
                                                <td>Since k=10 is constant</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <div class="success-box">
                                        <h4>✅ When is it Linear?</h4>
                                        <p>If d is constant (fixed-length keys):</p>
                                        <ul>
                                            <li><strong>Phone numbers:</strong> d=10 → O(10n) = O(n) ✓</li>
                                            <li><strong>SSN:</strong> d=9 → O(9n) = O(n) ✓</li>
                                            <li><strong>3-digit numbers:</strong> d=3 → O(3n) = O(n) ✓</li>
                                        </ul>
                                        <p><strong>Linear time for fixed-length keys!</strong></p>
                                    </div>

                                    <!-- When to Use -->
                                    <h2>When to Use Radix Sort</h2>

                                    <div class="success-box">
                                        <h4>✅ Perfect For:</h4>
                                        <ul>
                                            <li><strong>Phone numbers:</strong> Fixed 10 digits</li>
                                            <li><strong>Social Security numbers:</strong> Fixed 9 digits</li>
                                            <li><strong>IP addresses:</strong> Fixed 4 bytes</li>
                                            <li><strong>Fixed-length strings:</strong> Same length</li>
                                            <li><strong>Database integer keys:</strong> Bounded range</li>
                                        </ul>
                                        <p><strong>Rule of thumb:</strong> If d is small and fixed, Radix Sort wins!</p>
                                    </div>

                                    <div class="warning-box">
                                        <h4>❌ Avoid When:</h4>
                                        <ul>
                                            <li><strong>Variable-length keys:</strong> Different d values</li>
                                            <li><strong>Large d:</strong> Many digits (64-bit integers)</li>
                                            <li><strong>Floating-point:</strong> Not integers</li>
                                            <li><strong>Need in-place:</strong> Radix needs O(n) space</li>
                                        </ul>
                                    </div>

                                    <!-- Comparison -->
                                    <h2>Radix Sort vs Others</h2>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Feature</th>
                                                <th>Counting Sort</th>
                                                <th>Radix Sort</th>
                                                <th>Quick Sort</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>Type</td>
                                                <td>Non-comparison</td>
                                                <td>Non-comparison ✓</td>
                                                <td>Comparison</td>
                                            </tr>
                                            <tr>
                                                <td>Time</td>
                                                <td>O(n + k)</td>
                                                <td>O(d × n) ✓</td>
                                                <td>O(n log n)</td>
                                            </tr>
                                            <tr>
                                                <td>Space</td>
                                                <td>O(k)</td>
                                                <td>O(n + k)</td>
                                                <td>O(log n) ✓</td>
                                            </tr>
                                            <tr>
                                                <td>Stable</td>
                                                <td>Yes ✓</td>
                                                <td>Yes ✓</td>
                                                <td>No</td>
                                            </tr>
                                            <tr>
                                                <td>Use When</td>
                                                <td>Small range</td>
                                                <td>Fixed-length ✓</td>
                                                <td>General purpose</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <div class="info-box">
                                        <h4>The Relationship</h4>
                                        <p><strong>Radix Sort builds on Counting Sort:</strong></p>
                                        <ul>
                                            <li><strong>Counting Sort:</strong> Single pass, small range only</li>
                                            <li><strong>Radix Sort:</strong> Multiple passes, extends to larger ranges!
                                            </li>
                                            <li><strong>Each Radix pass:</strong> Uses Counting Sort on one digit</li>
                                            <li><strong>Together:</strong> Complete the non-comparison sorting toolkit!
                                            </li>
                                        </ul>
                                    </div>

                                    <!-- Common Misconceptions -->
                                    <h2>Common Misconceptions</h2>

                                    <div class="mistake-box">
                                        <h4>❌ Misconception 1: "Radix Sort is always O(n)"</h4>
                                        <p><strong>Reality:</strong> It's O(d × n) - depends on d!</p>
                                        <ul>
                                            <li><strong>Fixed d:</strong> O(n) ✓ (phone numbers, d=10)</li>
                                            <li><strong>Growing d:</strong> Not O(n)! (64-bit ints, d=20)</li>
                                            <li><strong>Variable d:</strong> Worst case dominates</li>
                                        </ul>
                                        <p><strong>Only linear for constant d!</strong></p>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>❌ Misconception 2: "Radix Sort doesn't need stability"</h4>
                                        <p><strong>Reality:</strong> Stability is CRUCIAL!</p>
                                        <ul>
                                            <li><strong>Without stability:</strong> Each pass destroys previous work
                                            </li>
                                            <li><strong>Example:</strong> [12, 22] sorted by tens → both have 1</li>
                                            <li><strong>If unstable:</strong> Could become [22, 12] after ones sort!
                                            </li>
                                            <li><strong>With stability:</strong> Preserves order, builds up sorting</li>
                                        </ul>
                                        <p><strong>Must use stable Counting Sort!</strong></p>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>❌ Misconception 3: "Radix Sort is faster than Quick Sort"</h4>
                                        <p><strong>Reality:</strong> Depends on d and n!</p>
                                        <ul>
                                            <li><strong>Small d:</strong> Radix wins (d=3: O(3n) vs O(n log n))</li>
                                            <li><strong>Large d:</strong> Quick wins (d=20: O(20n) vs O(n log n))</li>
                                            <li><strong>For n=1M:</strong> O(n log n) ≈ O(20n)</li>
                                            <li><strong>Crossover:</strong> Depends on constants and cache</li>
                                        </ul>
                                        <p><strong>Benchmark for your specific use case!</strong></p>
                                    </div>

                                    <div class="tip-box">
                                        <h4>💡 Key Takeaway</h4>
                                        <p>Radix Sort is a <strong>powerful extension of Counting Sort</strong>:</p>
                                        <ul>
                                            <li>✅ O(d × n) - linear for fixed-length keys</li>
                                            <li>✅ Non-comparison - breaks O(n log n) barrier</li>
                                            <li>✅ Stable - preserves order</li>
                                            <li>✅ Perfect for phone numbers, IDs, fixed-length data</li>
                                            <li>⚠️ Requires stability - must use stable Counting Sort</li>
                                            <li>⚠️ Not for variable-length or large d</li>
                                        </ul>
                                        <p><strong>Understanding Radix Sort completes your non-comparison sorting
                                                toolkit!</strong></p>
                                    </div>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <h3>The 3-Point Radix Sort Guide</h3>
                                        <ol>
                                            <li><strong>Strategy:</strong> Sort digit-by-digit using stable Counting
                                                Sort - extends to larger ranges!</li>
                                            <li><strong>Complexity:</strong> O(d × n) - linear for fixed-length keys!
                                            </li>
                                            <li><strong>Trade-off:</strong> Speed for fixed-length vs limited to
                                                integers/strings</li>
                                        </ol>
                                        <p style="margin-top: 1rem;"><strong>Interview tip:</strong> Mention Radix Sort
                                            for fixed-length integer keys. Explain digit-by-digit sorting, why stability
                                            is crucial, and when it beats comparison sorts!</p>
                                    </div>

                                    <h2>What's Next?</h2>
                                    <p>You've mastered non-comparison sorting! Next: <strong>Tim Sort</strong> - the
                                        hybrid algorithm that powers Python and Java!</p>

                                    <div class="tip-box">
                                        <strong>Practice:</strong> Implement Radix Sort for sorting phone numbers. Try
                                        both LSD and MSD approaches!
                                    </div>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="counting-sort.jsp" />
                                    <jsp:param name="prevTitle" value="Counting Sort" />
                                    <jsp:param name="nextLink" value="tim-sort.jsp" />
                                    <jsp:param name="nextTitle" value="Tim Sort" />
                                    <jsp:param name="currentLessonId" value="radix-sort" />
                                </jsp:include>
                            </article>
                    </main>

                    <%@ include file="../tutorial-footer.jsp" %>
            </div>

            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/python.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/progress.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/tutorial-core.js?v=4"></script>
            <script src="<%=request.getContextPath()%>/tutorials/dsa/algorithms/radix-sort-viz.js"></script>
        </body>

        </html>