<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "heap-sort" ); request.setAttribute("currentModule", "Sorting Algorithms"
        ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Heap Sort - DSA Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Learn Heap Sort - guaranteed O(n log n) with O(1) space! Master heap data structure, heapify, and in-place sorting.">
            <meta name="keywords" content="heap sort, max heap, heapify, O(n log n), in-place sort, DSA">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Heap Sort - DSA Tutorial">
            <meta property="og:description"
                content="Master Heap Sort - guaranteed O(n log n) performance with in-place sorting using heap data structure.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/dsa/heap-sort.jsp">
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
        "name": "Heap Sort Algorithm",
        "description": "Learn Heap Sort with guaranteed O(n log n) performance and in-place sorting using heap data structure.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Intermediate",
        "teaches": ["Heap Sort", "Max Heap", "Heapify", "O(n log n)", "In-place Sorting"],
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

        <body class="tutorial-body no-preview" data-lesson="heap-sort">
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
                                    <span>Heap Sort</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">🏆 Heap Sort</h1>
                                    <div class="lesson-meta">
                                        <span>Intermediate</span>
                                        <span>~15 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">You're organizing a knockout tournament with hundreds of players.
                                        You need to find the champion, then the runner-up, then third place, and so on.
                                        The <strong>smart way</strong>: Build a tournament bracket (max heap) where the
                                        strongest always rises to the top. Extract the champion, reorganize, repeat.
                                        That's Heap Sort!</p>

                                    <!-- Section 1: The Tournament Organizer -->
                                    <h2>The Tournament Organizer</h2>

                                    <p>Imagine a tournament tree where every parent is stronger than their children. The
                                        root? That's always the champion!</p>

                                    <div class="info-box">
                                        <h4>The Strategy</h4>
                                        <ol>
                                            <li><strong>Build a max heap:</strong> Organize players so strongest is at
                                                top</li>
                                            <li><strong>Extract the champion:</strong> Take the root (maximum element)
                                            </li>
                                            <li><strong>Reorganize:</strong> Heapify the remaining players</li>
                                            <li><strong>Repeat:</strong> Until everyone is ranked</li>
                                        </ol>
                                        <p><strong>Key insight:</strong> The heap always keeps the maximum at the root!
                                            Each extraction takes O(log n) time.</p>
                                    </div>

                                    <h3>What is a Heap?</h3>

                                    <div class="success-box">
                                        <h4>Heap Data Structure</h4>
                                        <p>A <strong>heap</strong> is a complete binary tree with a special property:
                                        </p>
                                        <ul>
                                            <li><strong>Max Heap:</strong> Every parent ≥ its children (root is maximum)
                                            </li>
                                            <li><strong>Min Heap:</strong> Every parent ≤ its children (root is minimum)
                                            </li>
                                            <li><strong>Complete:</strong> All levels filled except possibly the last,
                                                which fills left-to-right</li>
                                        </ul>
                                        <p><strong>For Heap Sort, we use a max heap!</strong></p>
                                    </div>

                                    <h3>Array Representation - The Magic!</h3>

                                    <p>Here's the beautiful part: <strong>We don't need pointers!</strong> A heap can be
                                        stored in an array:</p>

                                    <div class="tip-box">
                                        <h4>Array Index Formulas</h4>
                                        <p>For an element at index <code>i</code>:</p>
                                        <ul>
                                            <li><strong>Left child:</strong> <code>2i + 1</code></li>
                                            <li><strong>Right child:</strong> <code>2i + 2</code></li>
                                            <li><strong>Parent:</strong> <code>(i - 1) / 2</code></li>
                                        </ul>
                                        <p><strong>Example:</strong> Element at index 1 has children at indices 3 and 4,
                                            parent at index 0.</p>
                                    </div>

                                    <!-- Visualization -->
                                    <h3>See It in Action</h3>
                                    <p>Watch how Heap Sort builds a max heap, then extracts elements one by one:</p>

                                    <div id="heapSortVisualization"></div>

                                    <div class="info-box">
                                        <h4>Understanding the Process</h4>
                                        <ul>
                                            <li>🟡 <strong>Yellow (Current):</strong> Node being heapified</li>
                                            <li>🟣 <strong>Purple (Comparing):</strong> Comparing with children</li>
                                            <li>🟠 <strong>Orange (Swapping):</strong> Elements being swapped</li>
                                            <li>🟢 <strong>Green (Sorted):</strong> Extracted from heap, in final
                                                position</li>
                                            <li><strong>Phase 1:</strong> Build max heap - O(n)</li>
                                            <li><strong>Phase 2:</strong> Extract max n times - O(n log n)</li>
                                            <li><strong>Total:</strong> O(n) + O(n log n) = <strong>O(n log n)</strong>
                                            </li>
                                        </ul>
                                    </div>

                                    <!-- Code Example -->
                                    <h3>The Code</h3>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="dsa/heap-sort-basic.py" />
                                        <jsp:param name="language" value="python" />
                                        <jsp:param name="editorId" value="compiler-heap-basic" />
                                    </jsp:include>

                                    <div class="tip-box">
                                        <strong>The Heapify Function:</strong> This is the core! It ensures the heap
                                        property by "sinking down" a node until it's in the right position. Compare with
                                        children, swap with the larger one, repeat.
                                    </div>

                                    <!-- Quick Quiz -->
                                    <h3>Quick Quiz</h3>
                                    <ul>
                                        <li>
                                            <strong>Why does building a heap take O(n) and not O(n log n)?</strong>
                                            <details>
                                                <summary>Show answer</summary>
                                                Surprising but true! Most nodes are near the bottom of the tree and only
                                                need to "sink down" a little. Only the root might sink all the way down.
                                                The math works out: sum of (nodes at level) × (distance to sink) = O(n).
                                                This is why we build bottom-up, not top-down!
                                            </details>
                                        </li>
                                        <li>
                                            <strong>How does Heap Sort achieve in-place sorting?</strong>
                                            <details>
                                                <summary>Show answer</summary>
                                                As we extract the max (root), we swap it with the last element in the
                                                heap, then reduce the heap size by 1. The extracted element stays at the
                                                end of the array. The heap shrinks from the right, and the sorted
                                                portion grows from the right. Same array, no extra space needed!
                                            </details>
                                        </li>
                                    </ul>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <!-- Complexity Analysis -->
                                    <h2>Why O(n log n) Guaranteed?</h2>

                                    <p>Let's break down the complexity:</p>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Operation</th>
                                                <th>Time</th>
                                                <th>Why</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>Build Max Heap</td>
                                                <td>O(n)</td>
                                                <td>Bottom-up heapify, most nodes sink little</td>
                                            </tr>
                                            <tr>
                                                <td>Extract Max (once)</td>
                                                <td>O(log n)</td>
                                                <td>Heapify from root to leaf</td>
                                            </tr>
                                            <tr>
                                                <td>Extract Max (n times)</td>
                                                <td>O(n log n)</td>
                                                <td>n extractions × O(log n) each</td>
                                            </tr>
                                            <tr>
                                                <td><strong>Total</strong></td>
                                                <td><strong>O(n log n)</strong></td>
                                                <td>O(n) + O(n log n) = O(n log n)</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <div class="success-box">
                                        <h4>✅ Guaranteed Performance!</h4>
                                        <ul>
                                            <li><strong>Best case:</strong> O(n log n)</li>
                                            <li><strong>Average case:</strong> O(n log n)</li>
                                            <li><strong>Worst case:</strong> O(n log n) ✓</li>
                                            <li><strong>Space:</strong> O(1) - in-place!</li>
                                        </ul>
                                        <p><strong>Unlike Quick Sort, Heap Sort has NO worst case degradation!</strong>
                                        </p>
                                    </div>

                                    <!-- Comparison with Other Sorts -->
                                    <h2>Heap Sort vs Others</h2>

                                    <p>How does Heap Sort compare to Merge Sort and Quick Sort?</p>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Feature</th>
                                                <th>Merge Sort</th>
                                                <th>Quick Sort</th>
                                                <th>Heap Sort</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>Strategy</td>
                                                <td>"Split evenly, merge"</td>
                                                <td>"Pivot, partition"</td>
                                                <td>"Tournament bracket"</td>
                                            </tr>
                                            <tr>
                                                <td>Best Case</td>
                                                <td>O(n log n)</td>
                                                <td>O(n log n)</td>
                                                <td>O(n log n)</td>
                                            </tr>
                                            <tr>
                                                <td>Worst Case</td>
                                                <td>O(n log n) ✓</td>
                                                <td>O(n²) ⚠️</td>
                                                <td>O(n log n) ✓</td>
                                            </tr>
                                            <tr>
                                                <td>Space</td>
                                                <td>O(n) - needs extra array</td>
                                                <td>O(log n) - recursion</td>
                                                <td>O(1) - in-place ✓</td>
                                            </tr>
                                            <tr>
                                                <td>Stable</td>
                                                <td>Yes ✓</td>
                                                <td>No</td>
                                                <td>No</td>
                                            </tr>
                                            <tr>
                                                <td>Cache Performance</td>
                                                <td>Good</td>
                                                <td>Excellent ✓</td>
                                                <td>Fair</td>
                                            </tr>
                                            <tr>
                                                <td>In Practice</td>
                                                <td>"Predictable"</td>
                                                <td>"Usually fastest" ✓</td>
                                                <td>"Guaranteed + in-place"</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <div class="info-box">
                                        <h4>The Verdict</h4>
                                        <p><strong>Heap Sort is the "safe choice":</strong></p>
                                        <ul>
                                            <li>✅ Guaranteed O(n log n) (like Merge Sort)</li>
                                            <li>✅ In-place with O(1) space (like Quick Sort)</li>
                                            <li>✅ No worst case surprises</li>
                                            <li>⚠️ Slower than Quick Sort in practice (cache misses)</li>
                                            <li>⚠️ Not stable (equal elements may swap)</li>
                                        </ul>
                                        <p><strong>Best of both worlds: guaranteed performance + minimal space!</strong>
                                        </p>
                                    </div>

                                    <!-- When to Use -->
                                    <h2>When to Use Heap Sort</h2>

                                    <div class="success-box">
                                        <h4>✅ Use When:</h4>
                                        <ul>
                                            <li><strong>Need guaranteed O(n log n):</strong> No worst case degradation
                                            </li>
                                            <li><strong>Limited memory:</strong> In-place with O(1) space</li>
                                            <li><strong>Can't afford worst case:</strong> Unlike Quick Sort</li>
                                            <li><strong>Building priority queue:</strong> Heap structure useful</li>
                                            <li><strong>Embedded systems:</strong> Predictable performance + low memory
                                            </li>
                                        </ul>
                                    </div>

                                    <div class="warning-box">
                                        <h4>❌ Avoid When:</h4>
                                        <ul>
                                            <li><strong>Need stability:</strong> Heap Sort is unstable</li>
                                            <li><strong>Need fastest average:</strong> Quick Sort usually faster</li>
                                            <li><strong>Cache performance critical:</strong> Quick Sort better locality
                                            </li>
                                            <li><strong>Small arrays:</strong> Insertion Sort better</li>
                                        </ul>
                                    </div>

                                    <div class="info-box">
                                        <h4>🎯 Real-World Use</h4>
                                        <p><strong>Where Heap Sort shines:</strong></p>
                                        <ul>
                                            <li><strong>Intro Sort:</strong> C++ std::sort uses Heap Sort as fallback
                                                when Quick Sort degrades</li>
                                            <li><strong>Priority Queues:</strong> Heap structure is perfect for this
                                            </li>
                                            <li><strong>Embedded Systems:</strong> Predictable performance + low memory
                                            </li>
                                            <li><strong>Real-time Systems:</strong> Guaranteed O(n log n) matters</li>
                                        </ul>
                                    </div>

                                    <!-- Common Misconceptions -->
                                    <h2>Common Misconceptions</h2>

                                    <div class="mistake-box">
                                        <h4>❌ Misconception 1: "Heap Sort is the fastest"</h4>
                                        <p><strong>Reality:</strong> Quick Sort is usually faster in practice!</p>
                                        <ul>
                                            <li><strong>Quick Sort:</strong> Better cache locality (works on nearby
                                                elements)</li>
                                            <li><strong>Heap Sort:</strong> Jumps around array (parent/child not
                                                adjacent)</li>
                                            <li><strong>Cache misses:</strong> Make Heap Sort slower despite same O(n
                                                log n)</li>
                                            <li><strong>Benchmark:</strong> Quick Sort often 2-3x faster on modern CPUs
                                            </li>
                                        </ul>
                                        <p><strong>But:</strong> Heap Sort wins on guaranteed performance!</p>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>❌ Misconception 2: "Building a heap is O(n log n)"</h4>
                                        <p><strong>Reality:</strong> It's O(n)! Surprisingly efficient!</p>
                                        <ul>
                                            <li><strong>Top-down:</strong> Insert n elements × O(log n) = O(n log n)
                                            </li>
                                            <li><strong>Bottom-up:</strong> Heapify from bottom = O(n) ✓</li>
                                            <li><strong>Why:</strong> Most nodes are near bottom, only sink a little
                                            </li>
                                            <li><strong>Math:</strong> Σ(nodes at level h) × h = O(n)</li>
                                        </ul>
                                        <p><strong>This is why we build bottom-up, not top-down!</strong></p>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>❌ Misconception 3: "Heap Sort is stable"</h4>
                                        <p><strong>Reality:</strong> No! Equal elements can change relative order.</p>
                                        <ul>
                                            <li><strong>Example:</strong> [3a, 3b, 1] → [1, 3b, 3a] (3b before 3a now!)
                                            </li>
                                            <li><strong>Why:</strong> Heapify doesn't preserve relative order</li>
                                            <li><strong>Swaps:</strong> Can move equal elements past each other</li>
                                            <li><strong>If need stable:</strong> Use Merge Sort instead</li>
                                        </ul>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>❌ Misconception 4: "Heaps are only for sorting"</h4>
                                        <p><strong>Reality:</strong> Heaps have many other uses!</p>
                                        <ul>
                                            <li><strong>Priority Queues:</strong> OS task scheduling, event handling
                                            </li>
                                            <li><strong>Dijkstra's Algorithm:</strong> Shortest path finding</li>
                                            <li><strong>Huffman Coding:</strong> Data compression</li>
                                            <li><strong>Top K Elements:</strong> Find k largest/smallest efficiently
                                            </li>
                                            <li><strong>Median Maintenance:</strong> Running median with two heaps</li>
                                        </ul>
                                        <p><strong>Learning Heap Sort teaches you a versatile data structure!</strong>
                                        </p>
                                    </div>

                                    <div class="tip-box">
                                        <h4>💡 Key Takeaway</h4>
                                        <p>Heap Sort is the <strong>"safe choice"</strong> for sorting:</p>
                                        <ul>
                                            <li>✅ Guaranteed O(n log n) - no worst case</li>
                                            <li>✅ In-place O(1) space - minimal memory</li>
                                            <li>✅ Teaches heap data structure - useful beyond sorting</li>
                                            <li>⚠️ Slower than Quick Sort in practice - cache misses</li>
                                            <li>⚠️ Not stable - can't preserve order of equals</li>
                                        </ul>
                                        <p><strong>Understanding Heap Sort teaches you about guaranteed performance,
                                                space efficiency, and the power of heap data structures!</strong></p>
                                    </div>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <h3>The 3-Point Heap Sort Guide</h3>
                                        <ol>
                                            <li><strong>Strategy:</strong> Build max heap (O(n)), extract max repeatedly
                                                (O(n log n)) - tournament bracket!</li>
                                            <li><strong>Complexity:</strong> O(n log n) guaranteed, O(1) space - best of
                                                Merge + Quick!</li>
                                            <li><strong>Trade-off:</strong> Guaranteed performance + minimal space vs
                                                cache performance</li>
                                        </ol>
                                        <p style="margin-top: 1rem;"><strong>Interview tip:</strong> Mention Heap Sort
                                            for guaranteed O(n log n) with in-place sorting. Explain heap property and
                                            array representation. Compare with Merge Sort (space) and Quick Sort (worst
                                            case)!</p>
                                    </div>

                                    <h2>What's Next?</h2>
                                    <p>You've mastered comparison-based O(n log n) sorts! Next: <strong>Counting
                                            Sort</strong> - breaking the O(n log n) barrier with linear-time sorting!
                                    </p>

                                    <div class="tip-box">
                                        <strong>Practice:</strong> Implement a priority queue using a heap. Try finding
                                        the k largest elements in an array using a min heap!
                                    </div>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="quick-sort.jsp" />
                                    <jsp:param name="prevTitle" value="Quick Sort" />
                                    <jsp:param name="nextLink" value="counting-sort.jsp" />
                                    <jsp:param name="nextTitle" value="Counting Sort" />
                                    <jsp:param name="currentLessonId" value="heap-sort" />
                                </jsp:include>
                            </article>
                    </main>

                    <%@ include file="../tutorial-footer.jsp" %>
            </div>

            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/python.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/progress.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/tutorial-core.js?v=4"></script>
            <script src="<%=request.getContextPath()%>/tutorials/dsa/algorithms/heap-sort-viz.js"></script>
        </body>

        </html>