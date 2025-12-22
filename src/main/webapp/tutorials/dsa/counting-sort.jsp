<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "counting-sort" );
        request.setAttribute("currentModule", "Sorting Algorithms" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Counting Sort - DSA Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Learn Counting Sort - break the O(n log n) barrier with O(n) linear time sorting! Master non-comparison sorting for small ranges.">
            <meta name="keywords" content="counting sort, O(n), linear time, non-comparison sort, DSA">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Counting Sort - DSA Tutorial">
            <meta property="og:description"
                content="Master Counting Sort - O(n) linear time sorting that breaks the comparison sort barrier.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/dsa/counting-sort.jsp">
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
        "name": "Counting Sort Algorithm",
        "description": "Learn Counting Sort with O(n) linear time complexity for sorting integers in small ranges.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Intermediate",
        "teaches": ["Counting Sort", "O(n)", "Linear Time", "Non-comparison Sort"],
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

        <body class="tutorial-body no-preview" data-lesson="counting-sort">
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
                                    <span>Counting Sort</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">🔢 Counting Sort</h1>
                                    <div class="lesson-meta">
                                        <span>Intermediate</span>
                                        <span>~12 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">You're grading 100 test papers, each scored 0-100. Instead of
                                        comparing scores, you have a <strong>smarter strategy</strong>: Count how many
                                        students got each score, then reconstruct the sorted list. <strong>No
                                            comparisons needed!</strong> That's Counting Sort - O(n) linear time!</p>

                                    <!-- Section 1: The Tally Counter -->
                                    <h2>The Tally Counter</h2>

                                    <p>Imagine a tally sheet with boxes for each possible score. Go through the papers
                                        once, making a tally mark for each score. Then read off the tallies in order!
                                    </p>

                                    <div class="info-box">
                                        <h4>The Strategy</h4>
                                        <ol>
                                            <li><strong>Find the range:</strong> Minimum to maximum values</li>
                                            <li><strong>Count occurrences:</strong> How many times each value appears
                                            </li>
                                            <li><strong>Reconstruct:</strong> Build sorted array from counts</li>
                                            <li><strong>Done in O(n) time!</strong> No comparisons!</li>
                                        </ol>
                                        <p><strong>Key insight:</strong> When values are in a small range, counting
                                            beats comparing!</p>
                                    </div>

                                    <h3>Breaking the O(n log n) Barrier!</h3>

                                    <div class="success-box">
                                        <h4>The Breakthrough</h4>
                                        <p>All comparison-based sorts (Merge, Quick, Heap) have a <strong>theoretical
                                                lower bound of O(n log n)</strong>.</p>
                                        <p><strong>Counting Sort breaks this barrier!</strong></p>
                                        <ul>
                                            <li><strong>Comparison sorts:</strong> O(n log n) minimum</li>
                                            <li><strong>Counting Sort:</strong> O(n + k) where k = range</li>
                                            <li><strong>When k is small:</strong> Basically O(n)! 🚀</li>
                                        </ul>
                                        <p><strong>How?</strong> It doesn't compare elements - it counts them!</p>
                                    </div>

                                    <!-- Visualization -->
                                    <h3>See It in Action</h3>
                                    <p>Watch how Counting Sort counts occurrences and reconstructs the sorted array:</p>

                                    <div id="countingSortVisualization"></div>

                                    <div class="info-box">
                                        <h4>Understanding the Process</h4>
                                        <ul>
                                            <li><strong>Phase 1:</strong> Count occurrences - O(n)</li>
                                            <li><strong>Phase 2:</strong> Reconstruct sorted array - O(n + k)</li>
                                            <li><strong>Total:</strong> O(n + k) linear time!</li>
                                            <li><strong>Tally marks:</strong> Visual count of each value</li>
                                            <li><strong>No comparisons:</strong> Just counting!</li>
                                        </ul>
                                    </div>

                                    <!-- Code Example -->
                                    <h3>The Code</h3>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="dsa/counting-sort-basic.py" />
                                        <jsp:param name="language" value="python" />
                                        <jsp:param name="editorId" value="compiler-counting-basic" />
                                    </jsp:include>

                                    <div class="tip-box">
                                        <strong>Two Versions:</strong> The basic version is simpler but not stable. The
                                        stable version uses cumulative counts and builds right-to-left to preserve the
                                        order of equal elements. This is crucial for Radix Sort!
                                    </div>

                                    <!-- Quick Quiz -->
                                    <h3>Quick Quiz</h3>
                                    <ul>
                                        <li>
                                            <strong>Why can Counting Sort be O(n) when comparison sorts are O(n log
                                                n)?</strong>
                                            <details>
                                                <summary>Show answer</summary>
                                                Counting Sort doesn't compare elements! It counts occurrences instead.
                                                The O(n log n) lower bound only applies to comparison-based sorting. By
                                                using a different approach (counting), we can beat this barrier for
                                                specific cases (small integer ranges).
                                            </details>
                                        </li>
                                        <li>
                                            <strong>When would Counting Sort be terrible?</strong>
                                            <details>
                                                <summary>Show answer</summary>
                                                When the range is huge! If you're sorting 100 numbers with values from 1
                                                to 1,000,000,000, you'd need a billion-element count array. That's
                                                impractical! Counting Sort only works well when the range (k) is small
                                                compared to the number of elements (n).
                                            </details>
                                        </li>
                                    </ul>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <!-- Complexity Analysis -->
                                    <h2>Why O(n + k)?</h2>

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
                                                <td>Find min/max</td>
                                                <td>O(n)</td>
                                                <td>Scan array once</td>
                                            </tr>
                                            <tr>
                                                <td>Count occurrences</td>
                                                <td>O(n)</td>
                                                <td>Scan array once, increment counts</td>
                                            </tr>
                                            <tr>
                                                <td>Reconstruct array</td>
                                                <td>O(n + k)</td>
                                                <td>Iterate through counts (k), place elements (n)</td>
                                            </tr>
                                            <tr>
                                                <td><strong>Total</strong></td>
                                                <td><strong>O(n + k)</strong></td>
                                                <td>Linear when k is small!</td>
                                            </tr>
                                            <tr>
                                                <td>Space</td>
                                                <td>O(k)</td>
                                                <td>Count array of size k</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <div class="success-box">
                                        <h4>✅ When k is Small</h4>
                                        <p>If k (range) is O(n) or smaller:</p>
                                        <ul>
                                            <li><strong>Time:</strong> O(n + k) = O(n) ✓</li>
                                            <li><strong>Example:</strong> Sorting 1 million ages (k=120) → O(1,000,000)
                                                linear!</li>
                                            <li><strong>Faster than:</strong> O(n log n) = O(20,000,000) for comparison
                                                sorts!</li>
                                        </ul>
                                    </div>

                                    <div class="warning-box">
                                        <h4>⚠️ When k is Large</h4>
                                        <p>If k (range) is much larger than n:</p>
                                        <ul>
                                            <li><strong>Time:</strong> O(n + k) ≈ O(k) - dominated by range!</li>
                                            <li><strong>Space:</strong> O(k) - huge count array!</li>
                                            <li><strong>Example:</strong> Sorting 100 numbers (n=100) with range
                                                1-1,000,000,000 (k=1B)</li>
                                            <li><strong>Result:</strong> Terrible! Use comparison sort instead!</li>
                                        </ul>
                                    </div>

                                    <!-- When to Use -->
                                    <h2>When to Use Counting Sort</h2>

                                    <div class="success-box">
                                        <h4>✅ Perfect For:</h4>
                                        <ul>
                                            <li><strong>Ages:</strong> 0-120 (k=120)</li>
                                            <li><strong>Grades:</strong> 0-100 or A-F (k=100 or 5)</li>
                                            <li><strong>Pixel intensities:</strong> 0-255 (k=255)</li>
                                            <li><strong>Small integers:</strong> Range is reasonable</li>
                                            <li><strong>Foundation for Radix Sort:</strong> Digit-by-digit sorting</li>
                                        </ul>
                                        <p><strong>Rule of thumb:</strong> If k ≤ n, Counting Sort wins!</p>
                                    </div>

                                    <div class="warning-box">
                                        <h4>❌ Terrible For:</h4>
                                        <ul>
                                            <li><strong>Arbitrary large integers:</strong> Range too big</li>
                                            <li><strong>Floating-point numbers:</strong> Not integers</li>
                                            <li><strong>Strings:</strong> Use Radix Sort instead</li>
                                            <li><strong>Sparse ranges:</strong> Few values in huge range</li>
                                        </ul>
                                        <p><strong>Example:</strong> Sorting [1, 1000000, 5, 999999] needs 1M count
                                            array for 4 numbers!</p>
                                    </div>

                                    <!-- Comparison with Other Sorts -->
                                    <h2>Counting Sort vs Others</h2>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Feature</th>
                                                <th>Quick Sort</th>
                                                <th>Heap Sort</th>
                                                <th>Counting Sort</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>Type</td>
                                                <td>Comparison</td>
                                                <td>Comparison</td>
                                                <td>Non-comparison ✓</td>
                                            </tr>
                                            <tr>
                                                <td>Time (avg)</td>
                                                <td>O(n log n)</td>
                                                <td>O(n log n)</td>
                                                <td>O(n + k) ✓</td>
                                            </tr>
                                            <tr>
                                                <td>Space</td>
                                                <td>O(log n) ✓</td>
                                                <td>O(1) ✓</td>
                                                <td>O(k)</td>
                                            </tr>
                                            <tr>
                                                <td>Stable</td>
                                                <td>No</td>
                                                <td>No</td>
                                                <td>Yes (stable version) ✓</td>
                                            </tr>
                                            <tr>
                                                <td>Use When</td>
                                                <td>General purpose</td>
                                                <td>Guaranteed + in-place</td>
                                                <td>Small integer range ✓</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <div class="info-box">
                                        <h4>The Verdict</h4>
                                        <p><strong>Counting Sort is a specialist:</strong></p>
                                        <ul>
                                            <li>✅ Unbeatable for small ranges - O(n) linear!</li>
                                            <li>✅ Foundation for Radix Sort</li>
                                            <li>✅ Stable version available</li>
                                            <li>⚠️ Only works for integers in small ranges</li>
                                            <li>⚠️ Space usage depends on range, not array size</li>
                                        </ul>
                                        <p><strong>Know your data, choose your algorithm!</strong></p>
                                    </div>

                                    <!-- Stable Version -->
                                    <h2>The Stable Version</h2>

                                    <p>Why do we need a stable version?</p>

                                    <div class="tip-box">
                                        <h4>Stability Matters for Radix Sort</h4>
                                        <p>When sorting by multiple keys (like sorting by last name, then first name),
                                            we need stability:</p>
                                        <ul>
                                            <li><strong>Example:</strong> Sorting students by grade, then by name</li>
                                            <li><strong>First:</strong> Sort by name (stable)</li>
                                            <li><strong>Then:</strong> Sort by grade (must be stable!)</li>
                                            <li><strong>Result:</strong> Students with same grade are still sorted by
                                                name</li>
                                        </ul>
                                        <p><strong>Radix Sort uses Counting Sort repeatedly for each digit - stability
                                                is crucial!</strong></p>
                                    </div>

                                    <p>The stable version uses <strong>cumulative counts</strong>:</p>

                                    <div class="success-box">
                                        <h4>How Cumulative Counts Work</h4>
                                        <ol>
                                            <li><strong>Count occurrences:</strong> count[i] = how many elements equal i
                                            </li>
                                            <li><strong>Make cumulative:</strong> count[i] += count[i-1]</li>
                                            <li><strong>Now count[i] =</strong> how many elements ≤ i</li>
                                            <li><strong>Build output:</strong> Right to left, place each element at
                                                count[value]-1</li>
                                            <li><strong>Result:</strong> Stable! Equal elements maintain original order
                                            </li>
                                        </ol>
                                    </div>

                                    <!-- Common Misconceptions -->
                                    <h2>Common Misconceptions</h2>

                                    <div class="mistake-box">
                                        <h4>❌ Misconception 1: "Counting Sort works for any data"</h4>
                                        <p><strong>Reality:</strong> Only for integers in a small range!</p>
                                        <ul>
                                            <li><strong>Integers:</strong> Yes ✓</li>
                                            <li><strong>Floats:</strong> No (can convert to integers)</li>
                                            <li><strong>Strings:</strong> No (use Radix Sort)</li>
                                            <li><strong>Objects:</strong> No (unless you extract integer keys)</li>
                                            <li><strong>Large range:</strong> No (space explosion!)</li>
                                        </ul>
                                        <p><strong>It's a specialist tool, not a general-purpose sort!</strong></p>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>❌ Misconception 2: "Counting Sort is always faster"</h4>
                                        <p><strong>Reality:</strong> Only when k (range) is small!</p>
                                        <ul>
                                            <li><strong>Small range (k ≤ n):</strong> Counting Sort wins! O(n) vs O(n
                                                log n)</li>
                                            <li><strong>Large range (k >> n):</strong> Comparison sorts win! O(n log n)
                                                vs O(k)</li>
                                            <li><strong>Example 1:</strong> 1M ages (n=1M, k=120) → Counting wins!</li>
                                            <li><strong>Example 2:</strong> 100 numbers, range 1-1B (n=100, k=1B) →
                                                Quick Sort wins!</li>
                                        </ul>
                                        <p><strong>Analyze your data before choosing!</strong></p>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>❌ Misconception 3: "Counting Sort is in-place"</h4>
                                        <p><strong>Reality:</strong> Needs O(k) extra space!</p>
                                        <ul>
                                            <li><strong>Count array:</strong> Size k (range)</li>
                                            <li><strong>Output array:</strong> Size n (stable version)</li>
                                            <li><strong>Total space:</strong> O(n + k)</li>
                                            <li><strong>Not in-place:</strong> Unlike Heap Sort or Quick Sort</li>
                                        </ul>
                                        <p><strong>Trade-off:</strong> Speed (O(n)) for space (O(k))</p>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>❌ Misconception 4: "Counting Sort is the fastest sort"</h4>
                                        <p><strong>Reality:</strong> Fastest for its specific use case!</p>
                                        <ul>
                                            <li><strong>For small ranges:</strong> Yes, unbeatable!</li>
                                            <li><strong>For general data:</strong> No, use comparison sorts</li>
                                            <li><strong>For strings:</strong> No, use Radix Sort</li>
                                            <li><strong>For large ranges:</strong> No, terrible!</li>
                                        </ul>
                                        <p><strong>Every algorithm has its niche!</strong></p>
                                    </div>

                                    <div class="tip-box">
                                        <h4>💡 Key Takeaway</h4>
                                        <p>Counting Sort is a <strong>game-changer for small ranges</strong>:</p>
                                        <ul>
                                            <li>✅ O(n) linear time - breaks O(n log n) barrier!</li>
                                            <li>✅ Non-comparison based - counts instead of compares</li>
                                            <li>✅ Stable version available - crucial for Radix Sort</li>
                                            <li>⚠️ Only for integers in small ranges</li>
                                            <li>⚠️ Space usage depends on range</li>
                                        </ul>
                                        <p><strong>Understanding Counting Sort teaches you that sometimes, a specialized
                                                tool beats a general-purpose one!</strong></p>
                                    </div>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <h3>The 3-Point Counting Sort Guide</h3>
                                        <ol>
                                            <li><strong>Strategy:</strong> Count occurrences, reconstruct - no
                                                comparisons needed!</li>
                                            <li><strong>Complexity:</strong> O(n + k) linear when k is small - breaks
                                                O(n log n) barrier!</li>
                                            <li><strong>Trade-off:</strong> Speed (O(n)) vs limited use case (small
                                                integer ranges)</li>
                                        </ol>
                                        <p style="margin-top: 1rem;"><strong>Interview tip:</strong> Mention Counting
                                            Sort for sorting integers in small ranges. Explain why it's O(n), when to
                                            use it, and why it needs stability for Radix Sort!</p>
                                    </div>

                                    <h2>What's Next?</h2>
                                    <p>You've learned the first non-comparison sort! Next: <strong>Radix Sort</strong> -
                                        extending Counting Sort to handle larger ranges by sorting digit-by-digit!</p>

                                    <div class="tip-box">
                                        <strong>Practice:</strong> Implement Counting Sort for sorting students by age.
                                        Then try the stable version for sorting by grade, then by name!
                                    </div>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="heap-sort.jsp" />
                                    <jsp:param name="prevTitle" value="Heap Sort" />
                                    <jsp:param name="nextLink" value="radix-sort.jsp" />
                                    <jsp:param name="nextTitle" value="Radix Sort" />
                                    <jsp:param name="currentLessonId" value="counting-sort" />
                                </jsp:include>
                            </article>
                    </main>

                    <%@ include file="../tutorial-footer.jsp" %>
            </div>

            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/python.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/progress.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/tutorial-core.js?v=4"></script>
            <script src="<%=request.getContextPath()%>/tutorials/dsa/algorithms/counting-sort-viz.js"></script>
        </body>

        </html>