<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "selection-sort" );
        request.setAttribute("currentModule", "Sorting Algorithms" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Selection Sort - DSA Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Learn Selection Sort - fewer swaps than Bubble Sort but still O(n²). Understand when to use it.">
            <meta name="keywords" content="selection sort, sorting algorithm, O(n²), minimum selection, DSA">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Selection Sort - DSA Tutorial">
            <meta property="og:description" content="Master Selection Sort with fewer swaps than Bubble Sort.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/dsa/selection-sort.jsp">
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
        "name": "Selection Sort Algorithm",
        "description": "Learn Selection Sort with fewer swaps than Bubble Sort.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Beginner",
        "teaches": ["Selection Sort", "Sorting Algorithms", "Algorithm Optimization"],
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

        <body class="tutorial-body no-preview" data-lesson="selection-sort">
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
                                    <span>Selection Sort</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">🎯 Selection Sort</h1>
                                    <div class="lesson-meta">
                                        <span>Beginner</span>
                                        <span>~12 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">Bubble Sort swaps elements repeatedly. What if swaps are expensive?
                                        Selection Sort finds the minimum element and swaps it once per pass - much fewer
                                        swaps! Let's see how.</p>

                                    <!-- Section 1: How It Works -->
                                    <h2>How Selection Sort Works</h2>

                                    <p>Selection Sort divides the array into sorted and unsorted portions. It repeatedly
                                        <strong>selects</strong> the minimum element from the unsorted portion and
                                        places it at the end of the sorted portion.
                                    </p>

                                    <div class="info-box">
                                        <h4>The Algorithm</h4>
                                        <ol>
                                            <li>Find the minimum element in the unsorted portion</li>
                                            <li>Swap it with the first element of the unsorted portion</li>
                                            <li>Move the boundary between sorted and unsorted</li>
                                            <li>Repeat until the entire array is sorted</li>
                                        </ol>
                                        <p><strong>Key difference from Bubble Sort:</strong> Only one swap per pass!</p>
                                    </div>

                                    <!-- Visualization -->
                                    <h3>See It in Action</h3>
                                    <p>Watch how Selection Sort finds the minimum and swaps it once per pass:</p>

                                    <div class="visualization-container">
                                        <div id="selectionSortVisualization"></div>
                                    </div>

                                    <div class="info-box">
                                        <h4>Color Legend</h4>
                                        <ul style="list-style: none; padding: 0;">
                                            <li>🔵 <strong>Blue:</strong> Unsorted elements</li>
                                            <li>🟣 <strong>Purple:</strong> Searching for minimum</li>
                                            <li>🔴 <strong>Pink:</strong> Current minimum found</li>
                                            <li>🟡 <strong>Yellow:</strong> Comparing elements</li>
                                            <li>🟠 <strong>Orange:</strong> Swapping</li>
                                            <li>🟢 <strong>Green:</strong> Sorted (in final position)</li>
                                        </ul>
                                    </div>

                                    <!-- Code Example -->
                                    <h3>The Code</h3>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="dsa/selection-sort-basic.py" />
                                        <jsp:param name="language" value="python" />
                                        <jsp:param name="editorId" value="compiler-selection-basic" />
                                    </jsp:include>

                                    <div class="tip-box">
                                        <strong>Why "Selection"?</strong> Because we <strong>select</strong> the minimum
                                        element in each pass!
                                    </div>

                                    <!-- Quick Quiz -->
                                    <h3>Quick Quiz</h3>
                                    <ul>
                                        <li>
                                            <strong>How many swaps does Selection Sort make for an array of size
                                                n?</strong>
                                            <details>
                                                <summary>Show answer</summary>
                                                At most n-1 swaps (one per pass). Bubble Sort can make up to n(n-1)/2
                                                swaps!
                                            </details>
                                        </li>
                                        <li>
                                            <strong>Is Selection Sort faster than Bubble Sort?</strong>
                                            <details>
                                                <summary>Show answer</summary>
                                                Both are O(n²) for comparisons. But Selection Sort makes fewer swaps, so
                                                it's faster when swaps are expensive (e.g., swapping large objects).
                                            </details>
                                        </li>
                                    </ul>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <!-- Comparison -->
                                    <h2>Bubble Sort vs Selection Sort: Complete Comparison</h2>

                                    <p>Both are O(n²) algorithms, but they have different strengths. Let's see the
                                        difference in action:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="dsa/selection-sort-comparison.py" />
                                        <jsp:param name="language" value="python" />
                                        <jsp:param name="editorId" value="compiler-selection-compare" />
                                    </jsp:include>

                                    <h3>Performance Comparison</h3>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Metric</th>
                                                <th>Bubble Sort</th>
                                                <th>Selection Sort</th>
                                                <th>Winner</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>Comparisons</td>
                                                <td>O(n²)</td>
                                                <td>O(n²)</td>
                                                <td>Tie</td>
                                            </tr>
                                            <tr>
                                                <td><strong>Swaps</strong></td>
                                                <td>O(n²)</td>
                                                <td><strong>O(n)</strong></td>
                                                <td>✅ Selection Sort</td>
                                            </tr>
                                            <tr>
                                                <td><strong>Best Case</strong></td>
                                                <td><strong>O(n)</strong> with flag</td>
                                                <td>O(n²) always</td>
                                                <td>✅ Bubble Sort</td>
                                            </tr>
                                            <tr>
                                                <td>Worst Case</td>
                                                <td>O(n²)</td>
                                                <td>O(n²)</td>
                                                <td>Tie</td>
                                            </tr>
                                            <tr>
                                                <td><strong>Stable</strong></td>
                                                <td><strong>Yes</strong></td>
                                                <td>No</td>
                                                <td>✅ Bubble Sort</td>
                                            </tr>
                                            <tr>
                                                <td>Space</td>
                                                <td>O(1)</td>
                                                <td>O(1)</td>
                                                <td>Tie</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <h3>Pros & Cons</h3>

                                    <div
                                        style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem; margin: 1.5rem 0;">
                                        <div>
                                            <h4 style="color: #3b82f6; margin-bottom: 1rem;">🫧 Bubble Sort</h4>

                                            <div class="success-box" style="margin-bottom: 1rem;">
                                                <h5>✅ Pros</h5>
                                                <ul style="margin: 0.5rem 0;">
                                                    <li><strong>Adaptive:</strong> O(n) on sorted data</li>
                                                    <li><strong>Stable:</strong> Preserves order of equal elements</li>
                                                    <li><strong>Simple:</strong> Easy to understand</li>
                                                    <li><strong>Early exit:</strong> Can detect sorted array</li>
                                                </ul>
                                            </div>

                                            <div class="warning-box">
                                                <h5>❌ Cons</h5>
                                                <ul style="margin: 0.5rem 0;">
                                                    <li><strong>Many swaps:</strong> O(n²) swaps</li>
                                                    <li><strong>Slow:</strong> Lots of element movement</li>
                                                    <li><strong>Not practical:</strong> Rarely used in production</li>
                                                </ul>
                                            </div>
                                        </div>

                                        <div>
                                            <h4 style="color: #ec4899; margin-bottom: 1rem;">🎯 Selection Sort</h4>

                                            <div class="success-box" style="margin-bottom: 1rem;">
                                                <h5>✅ Pros</h5>
                                                <ul style="margin: 0.5rem 0;">
                                                    <li><strong>Fewer swaps:</strong> Only O(n) swaps</li>
                                                    <li><strong>Predictable:</strong> Always same number of comparisons
                                                    </li>
                                                    <li><strong>Good for expensive swaps:</strong> Minimizes writes</li>
                                                    <li><strong>Simple:</strong> Easy to implement</li>
                                                </ul>
                                            </div>

                                            <div class="warning-box">
                                                <h5>❌ Cons</h5>
                                                <ul style="margin: 0.5rem 0;">
                                                    <li><strong>Not adaptive:</strong> Always O(n²)</li>
                                                    <li><strong>Not stable:</strong> Can change order of equals</li>
                                                    <li><strong>No early exit:</strong> Can't detect sorted array</li>
                                                </ul>
                                            </div>
                                        </div>
                                    </div>

                                    <h3>When to Use Which?</h3>

                                    <div class="info-box">
                                        <h4>🫧 Choose Bubble Sort When:</h4>
                                        <ul>
                                            <li>✅ Array might be <strong>nearly sorted</strong> (can exit early)</li>
                                            <li>✅ You need <strong>stable sorting</strong> (preserve order of equal
                                                elements)</li>
                                            <li>✅ Learning sorting algorithms (simplest to understand)</li>
                                            <li>✅ Swaps are cheap, comparisons are expensive</li>
                                        </ul>
                                        <p style="margin-top: 1rem;"><strong>Example:</strong> Sorting a list that's
                                            already 90% sorted - Bubble Sort will finish in ~O(n) time!</p>
                                    </div>

                                    <div class="info-box">
                                        <h4>🎯 Choose Selection Sort When:</h4>
                                        <ul>
                                            <li>✅ <strong>Swaps are expensive</strong> (e.g., swapping large objects,
                                                database records)</li>
                                            <li>✅ <strong>Memory writes are costly</strong> (embedded systems, flash
                                                memory)</li>
                                            <li>✅ You want <strong>predictable performance</strong> (always same
                                                comparisons)</li>
                                            <li>✅ Stability is not required</li>
                                        </ul>
                                        <p style="margin-top: 1rem;"><strong>Example:</strong> Sorting large objects
                                            where each swap is expensive - Selection Sort minimizes swaps!</p>
                                    </div>

                                    <div class="tip-box">
                                        <h4>💡 Real-World Scenario</h4>
                                        <p><strong>Sorting 1000 student records by grade:</strong></p>
                                        <ul>
                                            <li><strong>If records are small (just numbers):</strong> Use Bubble Sort
                                                with optimization - might exit early if data is nearly sorted</li>
                                            <li><strong>If records are large (full student objects):</strong> Use
                                                Selection Sort - only ~1000 swaps instead of ~500,000!</li>
                                            <li><strong>If you need to preserve order of students with same
                                                    grade:</strong> Use Bubble Sort (stable)</li>
                                            <li><strong>Best choice for production:</strong> Neither! Use Quick Sort or
                                                Merge Sort (O(n log n))</li>
                                        </ul>
                                    </div>

                                    <!-- Complexity Analysis -->
                                    <h2>Complexity Analysis</h2>

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
                                                <td>O(n²)</td>
                                                <td>Always scans entire unsorted portion</td>
                                            </tr>
                                            <tr>
                                                <td>Average</td>
                                                <td>O(n²)</td>
                                                <td>Nested loops</td>
                                            </tr>
                                            <tr>
                                                <td>Worst</td>
                                                <td>O(n²)</td>
                                                <td>No early exit possible</td>
                                            </tr>
                                            <tr>
                                                <td>Space</td>
                                                <td>O(1)</td>
                                                <td>In-place sorting</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <div class="warning-box">
                                        <h4>⚠️ No Optimization</h4>
                                        <p>Unlike Bubble Sort, Selection Sort <strong>cannot</strong> exit early even if
                                            the array is already sorted. It always makes O(n²) comparisons.</p>
                                    </div>

                                    <!-- When to Use -->
                                    <h2>When to Use Selection Sort</h2>

                                    <div class="success-box">
                                        <h4>✅ Use When:</h4>
                                        <ul>
                                            <li>Swaps are expensive (e.g., swapping large objects)</li>
                                            <li>Memory writes are costly</li>
                                            <li>Array is small (< 100 elements)</li>
                                            <li>Simplicity matters</li>
                                        </ul>
                                    </div>

                                    <div class="warning-box">
                                        <h4>❌ Avoid When:</h4>
                                        <ul>
                                            <li>Array is large (O(n²) is too slow)</li>
                                            <li>Need stable sorting</li>
                                            <li>Array might be nearly sorted</li>
                                            <li>Better alternatives available</li>
                                        </ul>
                                    </div>

                                    <!-- Common Mistakes -->
                                    <h2>Common Misconceptions</h2>

                                    <div class="mistake-box">
                                        <h4>❌ Misconception 1: "Selection Sort is faster than Bubble Sort"</h4>
                                        <p><strong>Reality:</strong> Both are O(n²) for comparisons. Selection Sort only
                                            wins when <strong>swaps are expensive</strong>.</p>
                                        <ul>
                                            <li>✅ <strong>Correct:</strong> "Selection Sort makes fewer swaps (O(n) vs
                                                O(n²))"</li>
                                            <li>✅ <strong>Correct:</strong> "Selection Sort is better when swapping is
                                                costly"</li>
                                            <li>❌ <strong>Wrong:</strong> "Selection Sort is always faster" - Not true!
                                                Same time complexity.</li>
                                        </ul>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>❌ Misconception 2: "Selection Sort can be optimized like Bubble Sort"</h4>
                                        <p><strong>Reality:</strong> Selection Sort <strong>cannot</strong> detect if
                                            the array is already sorted and exit early.</p>
                                        <ul>
                                            <li>✅ <strong>Bubble Sort:</strong> Can use a flag to detect no swaps → exit
                                                early → O(n) best case</li>
                                            <li>❌ <strong>Selection Sort:</strong> Must always find minimum in each pass
                                                → Always O(n²)</li>
                                            <li><strong>Why?</strong> Selection Sort doesn't know if elements are in
                                                order until it checks all of them</li>
                                        </ul>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>❌ Misconception 3: "Fewer swaps means Selection Sort is stable"</h4>
                                        <p><strong>Reality:</strong> Selection Sort is <strong>NOT stable</strong> - it
                                            can change the relative order of equal elements.</p>
                                        <p><strong>Example:</strong> Sorting [4a, 2, 4b, 1] by value:</p>
                                        <ul>
                                            <li><strong>Selection Sort:</strong> [1, 2, 4b, 4a] ❌ - Order of 4a and 4b
                                                changed!</li>
                                            <li><strong>Bubble Sort:</strong> [1, 2, 4a, 4b] ✅ - Order preserved</li>
                                            <li><strong>Why?</strong> Selection Sort swaps distant elements, which can
                                                jump over equal values</li>
                                        </ul>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>❌ Misconception 4: "Selection Sort is good for nearly sorted data"</h4>
                                        <p><strong>Reality:</strong> Selection Sort performs the <strong>same</strong>
                                            regardless of initial order!</p>
                                        <ul>
                                            <li>❌ <strong>Selection Sort:</strong> Always O(n²) - doesn't matter if data
                                                is sorted or not</li>
                                            <li>✅ <strong>Bubble Sort:</strong> O(n) on sorted data, O(n²) on random
                                                data</li>
                                            <li>✅ <strong>Insertion Sort:</strong> O(n) on nearly sorted data - BEST
                                                choice for this case!</li>
                                        </ul>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>❌ Misconception 5: "Use Selection Sort for production code"</h4>
                                        <p><strong>Reality:</strong> Both Bubble and Selection Sort are O(n²) -
                                            <strong>too slow</strong> for real applications!</p>
                                        <ul>
                                            <li><strong>For small arrays (< 50):</strong> Use Insertion Sort (O(n²) but
                                                        faster in practice)</li>
                                            <li><strong>For general use:</strong> Use Quick Sort or Merge Sort (O(n log
                                                n))</li>
                                            <li><strong>For nearly sorted:</strong> Use Insertion Sort (O(n) best case)
                                            </li>
                                            <li><strong>Selection Sort?</strong> Only when swaps are extremely expensive
                                                (rare!)</li>
                                        </ul>
                                    </div>

                                    <div class="tip-box">
                                        <h4>💡 Key Takeaway</h4>
                                        <p>Selection Sort is a <strong>teaching tool</strong> to understand:</p>
                                        <ul>
                                            <li>✅ Trade-off between comparisons and swaps</li>
                                            <li>✅ Why stability matters</li>
                                            <li>✅ Why adaptivity is valuable</li>
                                            <li>✅ When O(n) swaps beats O(n²) swaps</li>
                                        </ul>
                                        <p><strong>In practice?</strong> Use better algorithms! Selection Sort teaches
                                            concepts, not production techniques.</p>
                                    </div>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <h3>The 3-Point Selection Sort Guide</h3>
                                        <ol>
                                            <li><strong>Pattern:</strong> Find minimum, swap once per pass</li>
                                            <li><strong>Advantage:</strong> O(n) swaps vs O(n²) for Bubble Sort</li>
                                            <li><strong>Limitation:</strong> Always O(n²) comparisons, not stable</li>
                                        </ol>
                                        <p style="margin-top: 1rem;"><strong>Interview tip:</strong> Mention Selection
                                            Sort when asked about minimizing swaps!</p>
                                    </div>

                                    <h2>What's Next?</h2>
                                    <p>Selection Sort improves on swaps, but we can do better! Next: <strong>Insertion
                                            Sort</strong> - works great on nearly sorted data and is stable!</p>

                                    <div class="tip-box">
                                        <strong>Practice:</strong> Try implementing Selection Sort to find the maximum
                                        instead of minimum (sorts in descending order)!
                                    </div>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="bubble-sort.jsp" />
                                    <jsp:param name="prevTitle" value="Bubble Sort" />
                                    <jsp:param name="nextLink" value="insertion-sort.jsp" />
                                    <jsp:param name="nextTitle" value="Insertion Sort" />
                                    <jsp:param name="currentLessonId" value="selection-sort" />
                                </jsp:include>
                            </article>
                    </main>

                    <%@ include file="../tutorial-footer.jsp" %>
            </div>

            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/python.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/progress.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/tutorial-core.js?v=4"></script>
            <script src="<%=request.getContextPath()%>/tutorials/dsa/algorithms/selection-sort-viz.js"></script>
        </body>

        </html>