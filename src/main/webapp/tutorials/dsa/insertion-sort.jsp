<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "insertion-sort" );
        request.setAttribute("currentModule", "Sorting Algorithms" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Insertion Sort - DSA Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Learn Insertion Sort - O(n) on sorted data! Perfect for nearly sorted arrays. Understand when it beats Quick Sort.">
            <meta name="keywords" content="insertion sort, adaptive sorting, O(n) best case, nearly sorted, DSA">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Insertion Sort - DSA Tutorial">
            <meta property="og:description"
                content="Master Insertion Sort - the adaptive algorithm that shines on nearly sorted data.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/dsa/insertion-sort.jsp">
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
        "name": "Insertion Sort Algorithm",
        "description": "Learn Insertion Sort - adaptive and efficient for nearly sorted data.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Beginner",
        "teaches": ["Insertion Sort", "Adaptive Algorithms", "Sorting Techniques"],
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

        <body class="tutorial-body no-preview" data-lesson="insertion-sort">
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
                                    <span>Insertion Sort</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">🃏 Insertion Sort</h1>
                                    <div class="lesson-meta">
                                        <span>Beginner</span>
                                        <span>~12 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">You're sorting playing cards in your hand. You pick up a new card
                                        and slide it into the correct position among the cards you're already holding.
                                        That's Insertion Sort! Simple, intuitive, and surprisingly fast when cards are
                                        nearly sorted.</p>

                                    <!-- Section 1: The Playing Cards Story -->
                                    <h2>The Playing Cards Analogy</h2>

                                    <p>Imagine you're playing cards. As you pick up each card, you insert it into its
                                        correct position in your hand:</p>

                                    <div class="info-box">
                                        <h4>How You Sort Cards</h4>
                                        <ol>
                                            <li>Start with one card (already "sorted")</li>
                                            <li>Pick up the next card</li>
                                            <li>Compare it with cards in your hand, right to left</li>
                                            <li>Slide cards to the right to make space</li>
                                            <li>Insert the new card in the correct position</li>
                                            <li>Repeat for all cards</li>
                                        </ol>
                                        <p><strong>Key insight:</strong> You maintain a sorted portion (your hand) and
                                            insert new elements one by one!</p>
                                    </div>

                                    <!-- Visualization -->
                                    <h3>See It in Action</h3>
                                    <p>Watch how Insertion Sort builds the sorted portion one element at a time:</p>

                                    <div class="visualization-container">
                                        <div id="insertionSortVisualization"></div>
                                    </div>

                                    <div class="info-box">
                                        <h4>Color Legend</h4>
                                        <ul style="list-style: none; padding: 0;">
                                            <li>🔵 <strong>Blue:</strong> Unsorted elements</li>
                                            <li>🟡 <strong>Yellow:</strong> Current key being inserted</li>
                                            <li>🟣 <strong>Purple:</strong> Comparing with sorted portion</li>
                                            <li>🟠 <strong>Orange:</strong> Shifting elements</li>
                                            <li>🟢 <strong>Green:</strong> Sorted portion</li>
                                        </ul>
                                    </div>

                                    <!-- Code Example -->
                                    <h3>The Code</h3>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="dsa/insertion-sort-basic.py" />
                                        <jsp:param name="language" value="python" />
                                        <jsp:param name="editorId" value="compiler-insertion-basic" />
                                    </jsp:include>

                                    <div class="tip-box">
                                        <strong>Why "Insertion"?</strong> Because we <strong>insert</strong> each
                                        element into its correct position in the sorted portion!
                                    </div>

                                    <!-- Quick Quiz -->
                                    <h3>Quick Quiz</h3>
                                    <ul>
                                        <li>
                                            <strong>Why is Insertion Sort O(n) on sorted data?</strong>
                                            <details>
                                                <summary>Show answer</summary>
                                                On sorted data, each element is already in the correct position! We only
                                                make one comparison per element (check if it's greater than the
                                                previous), then move to the next. That's n comparisons total = O(n)!
                                            </details>
                                        </li>
                                        <li>
                                            <strong>When is Insertion Sort O(n²)?</strong>
                                            <details>
                                                <summary>Show answer</summary>
                                                On reverse-sorted data! Each element must be compared with ALL previous
                                                elements and shifted all the way to the beginning. That's 1+2+3+...+n
                                                comparisons = O(n²).
                                            </details>
                                        </li>
                                    </ul>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <!-- Adaptive Nature -->
                                    <h2>The Power of Adaptivity</h2>

                                    <p>Insertion Sort's superpower: it's <strong>adaptive</strong> - performance depends
                                        on how sorted the input already is!</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="dsa/insertion-sort-adaptive.py" />
                                        <jsp:param name="language" value="python" />
                                        <jsp:param name="editorId" value="compiler-insertion-adaptive" />
                                    </jsp:include>

                                    <div class="success-box">
                                        <h4>Adaptivity in Action</h4>
                                        <ul>
                                            <li><strong>Sorted data:</strong> O(n) - Just n comparisons!</li>
                                            <li><strong>Nearly sorted:</strong> ~O(n) - Very few shifts needed</li>
                                            <li><strong>Random data:</strong> O(n²) - Many shifts required</li>
                                            <li><strong>Reverse sorted:</strong> O(n²) - Worst case</li>
                                        </ul>
                                    </div>

                                    <!-- Comparison Section (NO CODE) -->
                                    <h2>Bubble vs Selection vs Insertion: The Showdown</h2>

                                    <p>You've learned three O(n²) algorithms. Let's compare them conceptually:</p>

                                    <h3>Performance Comparison</h3>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Metric</th>
                                                <th>Bubble Sort</th>
                                                <th>Selection Sort</th>
                                                <th>Insertion Sort</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><strong>Best Case</strong></td>
                                                <td>O(n) with flag</td>
                                                <td>O(n²) always</td>
                                                <td><strong>O(n)</strong> ✅</td>
                                            </tr>
                                            <tr>
                                                <td><strong>Average Case</strong></td>
                                                <td>O(n²)</td>
                                                <td>O(n²)</td>
                                                <td>O(n²)</td>
                                            </tr>
                                            <tr>
                                                <td><strong>Worst Case</strong></td>
                                                <td>O(n²)</td>
                                                <td>O(n²)</td>
                                                <td>O(n²)</td>
                                            </tr>
                                            <tr>
                                                <td><strong>Swaps</strong></td>
                                                <td>O(n²)</td>
                                                <td>O(n)</td>
                                                <td>O(n²)</td>
                                            </tr>
                                            <tr>
                                                <td><strong>Stable</strong></td>
                                                <td>Yes</td>
                                                <td>No</td>
                                                <td><strong>Yes</strong> ✅</td>
                                            </tr>
                                            <tr>
                                                <td><strong>Adaptive</strong></td>
                                                <td>Yes (with flag)</td>
                                                <td>No</td>
                                                <td><strong>Yes</strong> ✅</td>
                                            </tr>
                                            <tr>
                                                <td><strong>Online</strong></td>
                                                <td>No</td>
                                                <td>No</td>
                                                <td><strong>Yes</strong> ✅</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <div class="tip-box">
                                        <strong>What's "Online"?</strong> An online algorithm can sort data as it
                                        arrives, without needing the entire dataset upfront. Insertion Sort can do this
                                        - perfect for streaming data!
                                    </div>

                                    <h3>Conceptual Differences</h3>

                                    <div
                                        style="display: grid; grid-template-columns: repeat(3, 1fr); gap: 1rem; margin: 1.5rem 0;">
                                        <div>
                                            <h4 style="color: #3b82f6; margin-bottom: 0.5rem;">🫧 Bubble Sort</h4>
                                            <p><strong>Strategy:</strong> Repeatedly swap adjacent elements</p>
                                            <p><strong>Builds:</strong> Sorted portion at the end</p>
                                            <p><strong>Best for:</strong> Nearly sorted data (with optimization)</p>
                                        </div>

                                        <div>
                                            <h4 style="color: #ec4899; margin-bottom: 0.5rem;">🎯 Selection Sort</h4>
                                            <p><strong>Strategy:</strong> Find minimum, swap once</p>
                                            <p><strong>Builds:</strong> Sorted portion at the beginning</p>
                                            <p><strong>Best for:</strong> Expensive swaps (large objects)</p>
                                        </div>

                                        <div>
                                            <h4 style="color: #10b981; margin-bottom: 0.5rem;">🃏 Insertion Sort</h4>
                                            <p><strong>Strategy:</strong> Insert each element into sorted portion</p>
                                            <p><strong>Builds:</strong> Sorted portion at the beginning</p>
                                            <p><strong>Best for:</strong> Nearly sorted or streaming data</p>
                                        </div>
                                    </div>

                                    <h3>When to Use Which?</h3>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Scenario</th>
                                                <th>Best Choice</th>
                                                <th>Why</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>Nearly sorted data</td>
                                                <td><strong>Insertion Sort</strong></td>
                                                <td>O(n) performance, adaptive</td>
                                            </tr>
                                            <tr>
                                                <td>Streaming data</td>
                                                <td><strong>Insertion Sort</strong></td>
                                                <td>Online algorithm</td>
                                            </tr>
                                            <tr>
                                                <td>Expensive swaps</td>
                                                <td><strong>Selection Sort</strong></td>
                                                <td>Only O(n) swaps</td>
                                            </tr>
                                            <tr>
                                                <td>Need stability</td>
                                                <td><strong>Bubble or Insertion</strong></td>
                                                <td>Both are stable</td>
                                            </tr>
                                            <tr>
                                                <td>Small arrays (< 50)</td>
                                                <td><strong>Insertion Sort</strong></td>
                                                <td>Simple, fast in practice</td>
                                            </tr>
                                            <tr>
                                                <td>Large random data</td>
                                                <td><strong>None!</strong></td>
                                                <td>Use Quick/Merge Sort (O(n log n))</td>
                                            </tr>
                                        </tbody>
                                    </table>

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
                                                <td>O(n)</td>
                                                <td>Already sorted - one comparison per element</td>
                                            </tr>
                                            <tr>
                                                <td>Average</td>
                                                <td>O(n²)</td>
                                                <td>Each element shifts halfway on average</td>
                                            </tr>
                                            <tr>
                                                <td>Worst</td>
                                                <td>O(n²)</td>
                                                <td>Reverse sorted - each element shifts all the way</td>
                                            </tr>
                                            <tr>
                                                <td>Space</td>
                                                <td>O(1)</td>
                                                <td>In-place sorting</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <!-- When to Use -->
                                    <h2>When to Use Insertion Sort</h2>

                                    <div class="success-box">
                                        <h4>✅ Use When:</h4>
                                        <ul>
                                            <li><strong>Nearly sorted data:</strong> Runs in ~O(n) time!</li>
                                            <li><strong>Small datasets:</strong> Simple and efficient (< 50
                                                    elements)</li>
                                            <li><strong>Streaming data:</strong> Can sort as data arrives</li>
                                            <li><strong>Need stability:</strong> Preserves order of equal elements</li>
                                            <li><strong>Part of hybrid algorithms:</strong> Used in Tim Sort, Intro Sort
                                            </li>
                                        </ul>
                                    </div>

                                    <div class="warning-box">
                                        <h4>❌ Avoid When:</h4>
                                        <ul>
                                            <li><strong>Large random data:</strong> O(n²) is too slow</li>
                                            <li><strong>Reverse sorted data:</strong> Worst case O(n²)</li>
                                            <li><strong>Better alternatives available:</strong> Use Quick/Merge Sort for
                                                large data</li>
                                        </ul>
                                    </div>

                                    <div class="info-box">
                                        <h4>🎯 Real-World Use</h4>
                                        <p><strong>Insertion Sort is used in production!</strong> Unlike Bubble and
                                            Selection Sort:</p>
                                        <ul>
                                            <li><strong>Tim Sort:</strong> Python's built-in sort uses Insertion Sort
                                                for small subarrays</li>
                                            <li><strong>Intro Sort:</strong> C++ STL uses Insertion Sort for small
                                                partitions</li>
                                            <li><strong>Database systems:</strong> For sorting small result sets</li>
                                            <li><strong>Embedded systems:</strong> Simple, low memory overhead</li>
                                        </ul>
                                    </div>

                                    <!-- Common Misconceptions -->
                                    <h2>Common Misconceptions</h2>

                                    <div class="mistake-box">
                                        <h4>❌ Misconception 1: "Insertion Sort is always O(n²) like Bubble and
                                            Selection"</h4>
                                        <p><strong>Reality:</strong> Insertion Sort is <strong>adaptive</strong> - O(n)
                                            on sorted data!</p>
                                        <ul>
                                            <li>✅ <strong>Sorted data:</strong> O(n) - just n comparisons</li>
                                            <li>✅ <strong>Nearly sorted:</strong> ~O(n) - very efficient</li>
                                            <li>❌ <strong>Random data:</strong> O(n²) - like the others</li>
                                        </ul>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>❌ Misconception 2: "Insertion Sort is never used in practice"</h4>
                                        <p><strong>Reality:</strong> It's used in <strong>production</strong> sorting
                                            algorithms!</p>
                                        <ul>
                                            <li><strong>Python's Tim Sort:</strong> Uses Insertion Sort for runs < 64
                                                    elements</li>
                                            <li><strong>C++ Intro Sort:</strong> Switches to Insertion Sort for small
                                                partitions</li>
                                            <li><strong>Why?</strong> Simple, fast on small/nearly-sorted data, low
                                                overhead</li>
                                        </ul>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>❌ Misconception 3: "Selection Sort is better because fewer swaps"</h4>
                                        <p><strong>Reality:</strong> Insertion Sort is usually <strong>faster in
                                                practice</strong>!</p>
                                        <ul>
                                            <li><strong>Selection Sort:</strong> Always O(n²), not adaptive, not stable
                                            </li>
                                            <li><strong>Insertion Sort:</strong> O(n) best case, adaptive, stable</li>
                                            <li><strong>In practice:</strong> Insertion Sort wins on most real-world
                                                data</li>
                                        </ul>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>❌ Misconception 4: "Can't sort streaming data"</h4>
                                        <p><strong>Reality:</strong> Insertion Sort is <strong>online</strong> - perfect
                                            for streaming!</p>
                                        <ul>
                                            <li><strong>Online algorithm:</strong> Can process data as it arrives</li>
                                            <li><strong>Example:</strong> Maintaining a sorted leaderboard as scores
                                                come in</li>
                                            <li><strong>Others:</strong> Bubble and Selection need all data upfront</li>
                                        </ul>
                                    </div>

                                    <div class="tip-box">
                                        <h4>💡 Key Takeaway</h4>
                                        <p>Insertion Sort is the <strong>most practical</strong> of the three O(n²)
                                            algorithms:</p>
                                        <ul>
                                            <li>✅ Adaptive (O(n) best case)</li>
                                            <li>✅ Stable</li>
                                            <li>✅ Online</li>
                                            <li>✅ Used in production (hybrid algorithms)</li>
                                            <li>✅ Simple and efficient for small data</li>
                                        </ul>
                                        <p><strong>For small or nearly-sorted data, Insertion Sort is often the best
                                                choice!</strong></p>
                                    </div>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <h3>The 3-Point Insertion Sort Guide</h3>
                                        <ol>
                                            <li><strong>Pattern:</strong> Insert each element into its correct position
                                                in the sorted portion</li>
                                            <li><strong>Advantage:</strong> O(n) on sorted data, stable, online
                                                algorithm</li>
                                            <li><strong>Use case:</strong> Small arrays, nearly sorted data, streaming
                                                data</li>
                                        </ol>
                                        <p style="margin-top: 1rem;"><strong>Interview tip:</strong> Mention Insertion
                                            Sort for nearly sorted data or when you need an online algorithm!</p>
                                    </div>

                                    <h2>What's Next?</h2>
                                    <p>You've mastered the three basic O(n²) sorts! Next: <strong>Merge Sort</strong> -
                                        our first O(n log n) algorithm using divide and conquer!</p>

                                    <div class="tip-box">
                                        <strong>Practice:</strong> Try implementing Insertion Sort for a linked list -
                                        it's actually easier than for arrays!
                                    </div>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="selection-sort.jsp" />
                                    <jsp:param name="prevTitle" value="Selection Sort" />
                                    <jsp:param name="nextLink" value="merge-sort.jsp" />
                                    <jsp:param name="nextTitle" value="Merge Sort" />
                                    <jsp:param name="currentLessonId" value="insertion-sort" />
                                </jsp:include>
                            </article>
                    </main>

                    <%@ include file="../tutorial-footer.jsp" %>
            </div>

            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/python.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/progress.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/tutorial-core.js?v=4"></script>
            <script src="<%=request.getContextPath()%>/tutorials/dsa/algorithms/insertion-sort-viz.js"></script>
        </body>

        </html>