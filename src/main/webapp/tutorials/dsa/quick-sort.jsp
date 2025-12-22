<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "quick-sort" ); request.setAttribute("currentModule", "Sorting Algorithms"
        ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Quick Sort - DSA Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Learn Quick Sort - the fastest sorting algorithm in practice! Master pivot selection, partitioning, and O(n log n) average performance.">
            <meta name="keywords" content="quick sort, pivot, partition, O(n log n), in-place sort, DSA">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Quick Sort - DSA Tutorial">
            <meta property="og:description"
                content="Master Quick Sort - the fastest sorting algorithm in practice with smart partitioning.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/dsa/quick-sort.jsp">
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
        "name": "Quick Sort Algorithm",
        "description": "Learn Quick Sort with pivot selection, partitioning, and O(n log n) average performance.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Intermediate",
        "teaches": ["Quick Sort", "Pivot Selection", "Partitioning", "O(n log n)"],
        "timeRequired": "PT15M",
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

        <body class="tutorial-body no-preview" data-lesson="quick-sort">
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
                                    <span>Quick Sort</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">⚡ Quick Sort</h1>
                                    <div class="lesson-meta">
                                        <span>Intermediate</span>
                                        <span>~15 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">You're organizing a library. Instead of comparing every book with
                                        every other book, you have a <strong>smarter strategy</strong>: Pick a reference
                                        book (the "pivot"), put smaller books on the left, larger books on the right.
                                        The pivot? <strong>It's already in its final spot!</strong> That's the power of
                                        Quick Sort!</p>

                                    <!-- Section 1: The Smart Organizer -->
                                    <h2>The Smart Organizer</h2>

                                    <p>Imagine sorting mail into "before M" and "after M" piles based on a reference
                                        letter:</p>

                                    <div class="info-box">
                                        <h4>The Strategy</h4>
                                        <ol>
                                            <li><strong>Pick a pivot:</strong> Choose a reference element (e.g., last
                                                element)</li>
                                            <li><strong>Partition:</strong> Move smaller elements left, larger elements
                                                right</li>
                                            <li><strong>Pivot is sorted!</strong> It's now in its final position</li>
                                            <li><strong>Recurse:</strong> Repeat for left and right subarrays</li>
                                        </ol>
                                        <p><strong>Key insight:</strong> Each partition puts ONE element in its final
                                            sorted position!</p>
                                    </div>

                                    <h3>How Quick Sort Works</h3>

                                    <div class="success-box">
                                        <h4>The Algorithm</h4>
                                        <ol>
                                            <li>If array has ≤ 1 element → already sorted! (base case)</li>
                                            <li>Choose a pivot (commonly last element)</li>
                                            <li>Partition: rearrange so smaller elements are left, larger are right</li>
                                            <li>Pivot is now in its final sorted position!</li>
                                            <li>Recursively sort left subarray</li>
                                            <li>Recursively sort right subarray</li>
                                        </ol>
                                    </div>

                                    <!-- Visualization -->
                                    <h3>See It in Action</h3>
                                    <p>Watch how Quick Sort picks a pivot, partitions around it, and recursively sorts:
                                    </p>

                                    <div id="quickSortVisualization"></div>

                                    <div class="info-box">
                                        <h4>Understanding the Process</h4>
                                        <ul>
                                            <li>🟡 <strong>Yellow (Pivot):</strong> Selected pivot element</li>
                                            <li>🟣 <strong>Purple (Comparing):</strong> Element being compared with
                                                pivot</li>
                                            <li>🟠 <strong>Orange (Swapping):</strong> Elements being swapped</li>
                                            <li>🟢 <strong>Green (Sorted):</strong> Pivot in final position</li>
                                            <li><strong>Each partition:</strong> O(n) work</li>
                                            <li><strong>Average depth:</strong> log n levels</li>
                                            <li><strong>Total:</strong> O(n) × O(log n) = <strong>O(n log n)</strong>
                                                average</li>
                                        </ul>
                                    </div>

                                    <!-- Code Example -->
                                    <h3>The Code</h3>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="dsa/quick-sort-basic.py" />
                                        <jsp:param name="language" value="python" />
                                        <jsp:param name="editorId" value="compiler-quick-basic" />
                                    </jsp:include>

                                    <div class="tip-box">
                                        <strong>The Partition Function:</strong> This is where the magic happens! We
                                        rearrange elements so that everything smaller than the pivot goes left,
                                        everything larger goes right. The pivot ends up in its final sorted position!
                                    </div>

                                    <!-- Quick Quiz -->
                                    <h3>Quick Quiz</h3>
                                    <ul>
                                        <li>
                                            <strong>Why does each partition put the pivot in its final
                                                position?</strong>
                                            <details>
                                                <summary>Show answer</summary>
                                                After partitioning, all elements to the left of the pivot are smaller,
                                                and all elements to the right are larger. This means the pivot is
                                                exactly where it belongs in the sorted array! No matter how we sort the
                                                left and right subarrays, the pivot won't move.
                                            </details>
                                        </li>
                                        <li>
                                            <strong>What happens if we always pick the smallest element as
                                                pivot?</strong>
                                            <details>
                                                <summary>Show answer</summary>
                                                Disaster! We'd partition into [nothing] and [everything else]. That's n
                                                levels of O(n) work = O(n²). This is why pivot selection matters! Always
                                                picking the first or last element can be bad if the data is already
                                                sorted.
                                            </details>
                                        </li>
                                    </ul>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <!-- Pivot Strategies -->
                                    <h2>Pivot Selection Strategies</h2>

                                    <p>The pivot choice can make or break Quick Sort's performance:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="dsa/quick-sort-pivots.py" />
                                        <jsp:param name="language" value="python" />
                                        <jsp:param name="editorId" value="compiler-quick-pivots" />
                                    </jsp:include>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Strategy</th>
                                                <th>Pros</th>
                                                <th>Cons</th>
                                                <th>Use When</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>Last Element</td>
                                                <td>Simple, fast</td>
                                                <td>O(n²) on sorted data!</td>
                                                <td>Random data only</td>
                                            </tr>
                                            <tr>
                                                <td>Middle Element</td>
                                                <td>Better than last</td>
                                                <td>Still can be bad</td>
                                                <td>Unknown data</td>
                                            </tr>
                                            <tr>
                                                <td>Random Element</td>
                                                <td>Prevents worst case</td>
                                                <td>Randomness overhead</td>
                                                <td>Adversarial data</td>
                                            </tr>
                                            <tr style="background: rgba(16, 185, 129, 0.1);">
                                                <td><strong>Median-of-Three</strong></td>
                                                <td><strong>Best overall</strong></td>
                                                <td>Slightly more complex</td>
                                                <td><strong>Production use!</strong></td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <!-- Complexity Analysis -->
                                    <h2>Why O(n log n) Average?</h2>

                                    <p>Let's break down the complexity:</p>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Case</th>
                                                <th>Time</th>
                                                <th>Why</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>Best</td>
                                                <td>O(n log n)</td>
                                                <td>Pivot always splits evenly</td>
                                            </tr>
                                            <tr>
                                                <td>Average</td>
                                                <td>O(n log n)</td>
                                                <td>Most pivots are reasonably good</td>
                                            </tr>
                                            <tr>
                                                <td>Worst</td>
                                                <td>O(n²)</td>
                                                <td>Pivot always smallest/largest (sorted data!)</td>
                                            </tr>
                                            <tr>
                                                <td>Space</td>
                                                <td>O(log n)</td>
                                                <td>Recursion stack depth</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <div class="warning-box">
                                        <h4>⚠️ The Worst Case</h4>
                                        <p>Unlike Merge Sort, Quick Sort can degrade to O(n²)!</p>
                                        <ul>
                                            <li><strong>When:</strong> Already sorted data with bad pivot choice</li>
                                            <li><strong>Why:</strong> Each partition only reduces size by 1</li>
                                            <li><strong>Solution:</strong> Use median-of-three or random pivot</li>
                                        </ul>
                                    </div>

                                    <!-- Comparison with Merge Sort -->
                                    <h2>Quick Sort vs Merge Sort</h2>

                                    <p>The big question: Which is better?</p>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Feature</th>
                                                <th>Merge Sort</th>
                                                <th>Quick Sort</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>Strategy</td>
                                                <td>"Split evenly, merge carefully"</td>
                                                <td>"Pick pivot, partition smartly"</td>
                                            </tr>
                                            <tr>
                                                <td>Best Case</td>
                                                <td>O(n log n)</td>
                                                <td>O(n log n)</td>
                                            </tr>
                                            <tr>
                                                <td>Average Case</td>
                                                <td>O(n log n)</td>
                                                <td>O(n log n)</td>
                                            </tr>
                                            <tr>
                                                <td>Worst Case</td>
                                                <td>O(n log n) ✓</td>
                                                <td>O(n²) ⚠️</td>
                                            </tr>
                                            <tr>
                                                <td>Space</td>
                                                <td>O(n) - needs extra array</td>
                                                <td>O(log n) - recursion only ✓</td>
                                            </tr>
                                            <tr>
                                                <td>Stable</td>
                                                <td>Yes ✓</td>
                                                <td>No</td>
                                            </tr>
                                            <tr>
                                                <td>In-Place</td>
                                                <td>No</td>
                                                <td>Yes ✓</td>
                                            </tr>
                                            <tr>
                                                <td>Cache Performance</td>
                                                <td>Good</td>
                                                <td>Excellent ✓</td>
                                            </tr>
                                            <tr>
                                                <td>In Practice</td>
                                                <td>"Steady and predictable"</td>
                                                <td>"Usually faster!" ✓</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <div class="info-box">
                                        <h4>The Verdict</h4>
                                        <p><strong>Quick Sort wins in practice!</strong> Here's why:</p>
                                        <ul>
                                            <li>✓ Better cache locality (works on nearby elements)</li>
                                            <li>✓ In-place (no extra memory needed)</li>
                                            <li>✓ Smaller constant factors</li>
                                            <li>✓ With good pivot selection, worst case is rare</li>
                                        </ul>
                                        <p><strong>But Merge Sort wins when:</strong></p>
                                        <ul>
                                            <li>✓ You need guaranteed O(n log n)</li>
                                            <li>✓ You need stability</li>
                                            <li>✓ Data might be adversarial</li>
                                        </ul>
                                    </div>

                                    <!-- When to Use -->
                                    <h2>When to Use Quick Sort</h2>

                                    <div class="success-box">
                                        <h4>✅ Use When:</h4>
                                        <ul>
                                            <li><strong>Need speed:</strong> Fastest in practice for random data</li>
                                            <li><strong>Limited memory:</strong> In-place with O(log n) space</li>
                                            <li><strong>Cache matters:</strong> Excellent cache performance</li>
                                            <li><strong>Random data:</strong> Average case is very likely</li>
                                            <li><strong>Can choose pivot:</strong> Median-of-three available</li>
                                        </ul>
                                    </div>

                                    <div class="warning-box">
                                        <h4>❌ Avoid When:</h4>
                                        <ul>
                                            <li><strong>Need guaranteed performance:</strong> Can be O(n²)</li>
                                            <li><strong>Need stability:</strong> Quick Sort is unstable</li>
                                            <li><strong>Data might be sorted:</strong> Worst case likely</li>
                                            <li><strong>Adversarial input:</strong> Someone might exploit worst case
                                            </li>
                                        </ul>
                                    </div>

                                    <div class="info-box">
                                        <h4>🎯 Real-World Use</h4>
                                        <p><strong>Quick Sort is everywhere!</strong></p>
                                        <ul>
                                            <li><strong>C++ std::sort():</strong> Uses Intro Sort (Quick + Heap)</li>
                                            <li><strong>Unix sort:</strong> Quick Sort variant</li>
                                            <li><strong>Java Arrays.sort():</strong> Dual-pivot Quick Sort for
                                                primitives</li>
                                            <li><strong>Databases:</strong> In-memory sorting</li>
                                        </ul>
                                    </div>

                                    <!-- Common Misconceptions -->
                                    <h2>Common Misconceptions</h2>

                                    <div class="mistake-box">
                                        <h4>❌ Misconception 1: "Quick Sort is always O(n log n)"</h4>
                                        <p><strong>Reality:</strong> It's O(n²) in the worst case!</p>
                                        <ul>
                                            <li><strong>Worst case:</strong> Already sorted data with bad pivot</li>
                                            <li><strong>Example:</strong> [1,2,3,4,5] with last element as pivot</li>
                                            <li><strong>Each partition:</strong> Only reduces size by 1</li>
                                            <li><strong>Total:</strong> n levels × O(n) work = O(n²)</li>
                                        </ul>
                                        <p><strong>Solution:</strong> Use median-of-three or random pivot!</p>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>❌ Misconception 2: "Quick Sort is always faster than Merge Sort"</h4>
                                        <p><strong>Reality:</strong> It depends on the data and implementation!</p>
                                        <ul>
                                            <li><strong>Random data:</strong> Quick Sort usually wins</li>
                                            <li><strong>Sorted data:</strong> Merge Sort wins (if bad pivot)</li>
                                            <li><strong>Small arrays:</strong> Insertion Sort wins!</li>
                                            <li><strong>Linked lists:</strong> Merge Sort wins (no random access)</li>
                                        </ul>
                                        <p><strong>Best choice:</strong> Depends on your specific use case!</p>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>❌ Misconception 3: "Quick Sort uses no extra space"</h4>
                                        <p><strong>Reality:</strong> Recursion uses O(log n) stack space!</p>
                                        <ul>
                                            <li><strong>Recursion depth:</strong> log n on average</li>
                                            <li><strong>Each call:</strong> Stores local variables on stack</li>
                                            <li><strong>Worst case:</strong> O(n) stack space (unbalanced)</li>
                                            <li><strong>Still better:</strong> Than Merge Sort's O(n) array</li>
                                        </ul>
                                        <p><strong>Note:</strong> Can be made iterative with explicit stack!</p>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>❌ Misconception 4: "Pivot selection doesn't matter much"</h4>
                                        <p><strong>Reality:</strong> It's the difference between O(n log n) and O(n²)!
                                        </p>
                                        <ul>
                                            <li><strong>Bad pivot:</strong> Always smallest/largest → O(n²)</li>
                                            <li><strong>Good pivot:</strong> Near median → O(n log n)</li>
                                            <li><strong>Last element:</strong> Terrible on sorted data</li>
                                            <li><strong>Median-of-three:</strong> Almost always good</li>
                                        </ul>
                                        <p><strong>Real libraries:</strong> Use sophisticated pivot selection!</p>
                                    </div>

                                    <div class="tip-box">
                                        <h4>💡 Key Takeaway</h4>
                                        <p>Quick Sort is <strong>fast in practice</strong> but not guaranteed:</p>
                                        <ul>
                                            <li>✅ Average case: O(n log n) - usually very fast</li>
                                            <li>✅ In-place: O(log n) space</li>
                                            <li>✅ Cache-friendly: Works on nearby elements</li>
                                            <li>⚠️ Worst case: O(n²) - rare with good pivot</li>
                                            <li>⚠️ Unstable: Equal elements may swap</li>
                                        </ul>
                                        <p><strong>Understanding Quick Sort teaches you about trade-offs, pivot
                                                selection, and why "average case" matters!</strong></p>
                                    </div>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <h3>The 3-Point Quick Sort Guide</h3>
                                        <ol>
                                            <li><strong>Strategy:</strong> Pick pivot, partition, recurse - each
                                                partition sorts ONE element</li>
                                            <li><strong>Complexity:</strong> O(n log n) average, O(n²) worst - pivot
                                                choice matters!</li>
                                            <li><strong>Trade-off:</strong> Speed and space efficiency vs guaranteed
                                                performance</li>
                                        </ol>
                                        <p style="margin-top: 1rem;"><strong>Interview tip:</strong> Mention Quick Sort
                                            for in-place sorting with good average performance. Explain partition
                                            process and why pivot selection matters. Compare with Merge Sort!</p>
                                    </div>

                                    <h2>What's Next?</h2>
                                    <p>You've completed Module 3: Sorting Algorithms! You now understand O(n²) sorts
                                        (Bubble, Selection, Insertion) and O(n log n) sorts (Merge, Quick). Next:
                                        <strong>Searching Algorithms</strong> and advanced data structures!
                                    </p>

                                    <div class="tip-box">
                                        <strong>Practice:</strong> Implement Quick Sort with different pivot strategies.
                                        Try the three-way partition for arrays with many duplicates!
                                    </div>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="merge-sort.jsp" />
                                    <jsp:param name="prevTitle" value="Merge Sort" />
                                    <jsp:param name="nextLink" value="heap-sort.jsp" />
                                    <jsp:param name="nextTitle" value="Heap Sort" />
                                    <jsp:param name="currentLessonId" value="quick-sort" />
                                </jsp:include>
                            </article>
                    </main>

                    <%@ include file="../tutorial-footer.jsp" %>
            </div>

            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/python.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/progress.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/tutorial-core.js?v=4"></script>
            <script src="<%=request.getContextPath()%>/tutorials/dsa/algorithms/quick-sort-viz.js"></script>
        </body>

        </html>