<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "binary-search-variants" );
        request.setAttribute("currentModule", "Searching Algorithms" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Binary Search Variants - DSA Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Master Binary Search Variants - FAANG interview favorites! Rotated array, first/last occurrence, peak element. All O(log n).">
            <meta name="keywords" content="binary search variants, rotated array, FAANG interview, O(log n), DSA">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Binary Search Variants - DSA Tutorial">
            <meta property="og:description"
                content="Master the binary search variants that appear in FAANG interviews.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/dsa/binary-search-variants.jsp">
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
        "name": "Binary Search Variants",
        "description": "Master binary search variants for FAANG interviews - rotated array, first/last occurrence, peak element.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Intermediate to Advanced",
        "teaches": ["Binary Search Variants", "Rotated Array", "Interview Problems", "O(log n)"],
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

        <body class="tutorial-body no-preview" data-lesson="binary-search-variants">
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
                                    <span>Binary Search Variants</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">🎯 Binary Search Variants</h1>
                                    <div class="lesson-meta">
                                        <span>Intermediate to Advanced</span>
                                        <span>~20 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">You've mastered Binary Search. Now it's time for the
                                        <strong>interview variants</strong> that appear constantly in FAANG interviews!
                                        These problems all use the same O(log n) binary search framework with clever
                                        modifications. Master these, and you'll ace binary search interview questions!
                                    </p>

                                    <h2>The Interview Favorites</h2>

                                    <div class="success-box">
                                        <h4>5 Must-Know Variants</h4>
                                        <ol>
                                            <li><strong>First/Last Occurrence</strong> - Find boundaries in duplicates
                                                ⭐⭐⭐⭐⭐</li>
                                            <li><strong>Rotated Sorted Array</strong> - Search in rotated array ⭐⭐⭐⭐⭐
                                            </li>
                                            <li><strong>Peak Element</strong> - Find local maximum ⭐⭐⭐⭐</li>
                                            <li><strong>Insert Position</strong> - Where to insert to maintain order ⭐⭐⭐
                                            </li>
                                            <li><strong>Square Root</strong> - Binary search on answer space ⭐⭐⭐</li>
                                        </ol>
                                        <p><strong>All use O(log n) binary search!</strong></p>
                                    </div>

                                    <h2>Variant 1: First and Last Occurrence</h2>

                                    <p><strong>Problem:</strong> Find the first and last position of a target in a
                                        sorted array with duplicates.</p>

                                    <div class="info-box">
                                        <h4>Example</h4>
                                        <p>Array: <code>[1, 2, 2, 2, 2, 3, 4]</code>, Target: <code>2</code></p>
                                        <p>First occurrence: index <code>1</code></p>
                                        <p>Last occurrence: index <code>4</code></p>
                                        <p>Count: <code>4</code> occurrences</p>
                                    </div>

                                    <div class="tip-box">
                                        <h4>The Trick</h4>
                                        <p><strong>Keep searching after finding!</strong></p>
                                        <ul>
                                            <li><strong>First occurrence:</strong> When found, search LEFT (right = mid
                                                - 1)</li>
                                            <li><strong>Last occurrence:</strong> When found, search RIGHT (left = mid +
                                                1)</li>
                                            <li><strong>Count:</strong> last - first + 1 in O(log n)!</li>
                                        </ul>
                                    </div>

                                    <h2>Variant 2: Rotated Sorted Array ⭐ Most Common!</h2>

                                    <p><strong>Problem:</strong> Search in a sorted array that has been rotated.</p>

                                    <div class="info-box">
                                        <h4>Example</h4>
                                        <p>Original: <code>[0, 1, 2, 4, 5, 6, 7]</code></p>
                                        <p>Rotated: <code>[4, 5, 6, 7, 0, 1, 2]</code> (rotated at index 4)</p>
                                        <p>Search for <code>0</code> → index <code>4</code></p>
                                    </div>

                                    <h3>See It in Action</h3>
                                    <p>Watch how we detect which half is sorted:</p>

                                    <div id="binarySearchVariantsVisualization"></div>

                                    <div class="success-box">
                                        <h4>✅ The Key Insight</h4>
                                        <p><strong>One half is ALWAYS sorted!</strong></p>
                                        <ol>
                                            <li>Compare <code>arr[left]</code> with <code>arr[mid]</code></li>
                                            <li>If <code>arr[left] ≤ arr[mid]</code>: Left half is sorted</li>
                                            <li>Otherwise: Right half is sorted</li>
                                            <li>Check if target is in the sorted half</li>
                                            <li>If yes, search sorted half; if no, search other half</li>
                                        </ol>
                                        <p><strong>Still O(log n)!</strong></p>
                                    </div>

                                    <h2>The Code</h2>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="dsa/binary-search-variants.py" />
                                        <jsp:param name="language" value="python" />
                                        <jsp:param name="editorId" value="compiler-variants" />
                                    </jsp:include>

                                    <h2>Variant 3: Peak Element</h2>

                                    <p><strong>Problem:</strong> Find a peak element (greater than its neighbors).</p>

                                    <div class="info-box">
                                        <h4>Example</h4>
                                        <p>Array: <code>[1, 3, 20, 4, 1, 0]</code></p>
                                        <p>Peak: <code>20</code> at index <code>2</code> (20 > 3 and 20 > 4)</p>
                                    </div>

                                    <div class="tip-box">
                                        <h4>The Strategy</h4>
                                        <p>Compare <code>arr[mid]</code> with <code>arr[mid + 1]</code>:</p>
                                        <ul>
                                            <li>If <code>arr[mid] < arr[mid + 1]</code>: Ascending, peak is RIGHT</li>
                                            <li>If <code>arr[mid] > arr[mid + 1]</code>: Descending, peak is LEFT or mid
                                            </li>
                                        </ul>
                                        <p><strong>Always converges to a peak!</strong></p>
                                    </div>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <h2>Variant 4: Insert Position</h2>

                                    <p><strong>Problem:</strong> Find the index where target should be inserted to
                                        maintain sorted order.</p>

                                    <div class="info-box">
                                        <h4>Example</h4>
                                        <p>Array: <code>[1, 3, 5, 6]</code>, Target: <code>2</code></p>
                                        <p>Insert at index <code>1</code> → <code>[1, 2, 3, 5, 6]</code></p>
                                    </div>

                                    <div class="tip-box">
                                        <h4>The Trick</h4>
                                        <p><strong>Return the left pointer when not found!</strong></p>
                                        <p>After binary search completes without finding target, <code>left</code>
                                            points to the correct insert position.</p>
                                    </div>

                                    <h2>Variant 5: Square Root</h2>

                                    <p><strong>Problem:</strong> Find integer square root without using sqrt().</p>

                                    <div class="info-box">
                                        <h4>Example</h4>
                                        <p><code>sqrt(8) = 2</code> (since 2² = 4 ≤ 8 < 3²=9)</p>
                                                <p><code>sqrt(16) = 4</code> (perfect square)</p>
                                    </div>

                                    <div class="success-box">
                                        <h4>Binary Search on Answer Space!</h4>
                                        <p>Instead of searching in an array, search in the range <code>[1, n/2]</code>:
                                        </p>
                                        <ul>
                                            <li>If <code>mid² == n</code>: Perfect square!</li>
                                            <li>If <code>mid² < n</code>: Answer might be mid, search right</li>
                                            <li>If <code>mid² > n</code>: Too large, search left</li>
                                        </ul>
                                        <p><strong>Same O(log n) approach, different search space!</strong></p>
                                    </div>

                                    <h2>Interview Tips</h2>

                                    <div class="success-box">
                                        <h4>✅ How to Ace Binary Search Variants</h4>
                                        <ol>
                                            <li><strong>Recognize the pattern:</strong> Can I eliminate half each step?
                                            </li>
                                            <li><strong>Start with template:</strong> Use standard binary search
                                                framework</li>
                                            <li><strong>Modify condition:</strong> Adjust the comparison/direction logic
                                            </li>
                                            <li><strong>Test edge cases:</strong> Empty array, single element,
                                                duplicates</li>
                                            <li><strong>Explain complexity:</strong> Always mention O(log n)</li>
                                        </ol>
                                    </div>

                                    <div class="warning-box">
                                        <h4>⚠️ Common Mistakes</h4>
                                        <ul>
                                            <li><strong>Rotated array:</strong> Forgetting to check which half is sorted
                                            </li>
                                            <li><strong>First/Last:</strong> Stopping search after first match</li>
                                            <li><strong>Peak element:</strong> Not handling array boundaries</li>
                                            <li><strong>All variants:</strong> Off-by-one errors in loop condition</li>
                                        </ul>
                                    </div>

                                    <h2>Complexity Analysis</h2>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Variant</th>
                                                <th>Time</th>
                                                <th>Space</th>
                                                <th>Difficulty</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>First/Last Occurrence</td>
                                                <td>O(log n)</td>
                                                <td>O(1)</td>
                                                <td>Medium</td>
                                            </tr>
                                            <tr>
                                                <td>Rotated Sorted Array</td>
                                                <td>O(log n)</td>
                                                <td>O(1)</td>
                                                <td>Medium-Hard</td>
                                            </tr>
                                            <tr>
                                                <td>Peak Element</td>
                                                <td>O(log n)</td>
                                                <td>O(1)</td>
                                                <td>Medium</td>
                                            </tr>
                                            <tr>
                                                <td>Insert Position</td>
                                                <td>O(log n)</td>
                                                <td>O(1)</td>
                                                <td>Easy-Medium</td>
                                            </tr>
                                            <tr>
                                                <td>Square Root</td>
                                                <td>O(log n)</td>
                                                <td>O(1)</td>
                                                <td>Medium</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <div class="tip-box">
                                        <h4>💡 Key Takeaway</h4>
                                        <p>Binary Search Variants are <strong>interview favorites</strong>:</p>
                                        <ul>
                                            <li>✅ All use O(log n) binary search framework</li>
                                            <li>✅ Modify condition/direction logic for each variant</li>
                                            <li>✅ Rotated array: Most common in FAANG interviews!</li>
                                            <li>✅ First/Last: Essential for counting in sorted arrays</li>
                                            <li>✅ Practice these - they appear constantly!</li>
                                        </ul>
                                        <p><strong>Master the template, adapt for each problem!</strong></p>
                                    </div>

                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <h3>The Binary Search Variants Guide</h3>
                                        <ol>
                                            <li><strong>Framework:</strong> All use standard binary search with
                                                modifications</li>
                                            <li><strong>Complexity:</strong> All are O(log n) - same as basic binary
                                                search</li>
                                            <li><strong>Interview:</strong> These appear constantly in FAANG interviews!
                                            </li>
                                        </ol>
                                        <p style="margin-top: 1rem;"><strong>Interview tip:</strong> When you see a
                                            sorted array problem, think binary search! For rotated arrays, remember one
                                            half is always sorted. For first/last, keep searching after finding.
                                            Practice these variants - they're interview gold!</p>
                                    </div>

                                    <h2>What's Next?</h2>
                                    <p>You've mastered binary search and its variants! Next: <strong>Interpolation
                                            Search</strong> - an optimization for uniformly distributed data.</p>

                                    <div class="tip-box">
                                        <strong>Practice:</strong> Solve these on LeetCode: "Search in Rotated Sorted
                                        Array", "Find First and Last Position", "Find Peak Element". These are FAANG
                                        favorites!
                                    </div>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="linear-search.jsp" />
                                    <jsp:param name="prevTitle" value="Linear Search" />
                                    <jsp:param name="nextLink" value="interpolation-search.jsp" />
                                    <jsp:param name="nextTitle" value="Interpolation Search" />
                                    <jsp:param name="currentLessonId" value="binary-search-variants" />
                                </jsp:include>
                            </article>
                    </main>

                    <%@ include file="../tutorial-footer.jsp" %>
            </div>

            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/python.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/progress.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/tutorial-core.js?v=4"></script>
            <script src="<%=request.getContextPath()%>/tutorials/dsa/algorithms/binary-search-variants-viz.js"></script>
        </body>

        </html>