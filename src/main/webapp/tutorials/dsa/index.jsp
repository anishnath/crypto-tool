<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%-- DSA Tutorial - Landing Page --%>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Data Structures & Algorithms Tutorial - Master DSA | 8gwifi.org</title>
            <meta name="description"
                content="Master Data Structures and Algorithms with interactive visualizations. Learn arrays, linked lists, trees, graphs, sorting, searching, and dynamic programming with real-world examples.">
            <meta name="keywords"
                content="data structures, algorithms, DSA tutorial, learn DSA, coding interview, algorithm visualization, sorting algorithms, graph algorithms, dynamic programming">
            <link rel="canonical" href="https://8gwifi.org/tutorials/dsa/">

            <link rel="icon" type="image/svg+xml"
                href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">

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
        "@type": "Course",
        "name": "Data Structures & Algorithms Tutorial",
        "description": "A comprehensive interactive course to master data structures and algorithms from fundamentals to advanced topics with visualizations.",
        "provider": {
            "@type": "Organization",
            "name": "8gwifi.org",
            "sameAs": "https://8gwifi.org"
        },
        "educationalLevel": "Beginner to Advanced",
        "teaches": ["Data Structures", "Algorithms", "Problem Solving", "Complexity Analysis", "Sorting", "Searching", "Trees", "Graphs", "Dynamic Programming"]
    }
    </script>

            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body">
            <div class="tutorial-layout">
                <%@ include file="../tutorial-header.jsp" %>

                    <main class="tutorial-main">
                        <%@ include file="../tutorial-sidebar-dsa.jsp" %>
                            <div class="overlay" id="sidebarOverlay" onclick="toggleSidebar()"></div>

                            <article class="tutorial-content" style="margin-right: 0;">
                                <nav class="breadcrumb">
                                    <a href="<%=request.getContextPath()%>/tutorials/">Tutorials</a>
                                    <span class="breadcrumb-separator">/</span>
                                    <span>DSA</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Data Structures & Algorithms</h1>
                                    <p
                                        style="font-size: var(--text-lg); color: var(--text-secondary); max-width: 700px;">
                                        Master the fundamentals of computer science. Learn data structures, algorithms,
                                        and problem-solving techniques with interactive visualizations and real-world
                                        examples.
                                    </p>
                                </header>

                                <div class="lesson-body">
                                    <div style="display: grid; gap: var(--space-4); margin-top: var(--space-8);">
                                        <%-- Start Learning Card --%>
                                            <a href="<%=request.getContextPath()%>/tutorials/dsa/intro.jsp" class="card"
                                                style="text-decoration: none; display: flex; align-items: center; gap: var(--space-4);">
                                                <div
                                                    style="width: 48px; height: 48px; background: var(--success-light); border-radius: var(--radius-md); display: flex; align-items: center; justify-content: center;">
                                                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none"
                                                        stroke="var(--success)" stroke-width="2">
                                                        <polygon points="5 3 19 12 5 21 5 3" />
                                                    </svg>
                                                </div>
                                                <div>
                                                    <h3
                                                        style="margin: 0; font-size: var(--text-lg); color: var(--text-primary);">
                                                        Start Learning</h3>
                                                    <p
                                                        style="margin: 0; color: var(--text-secondary); font-size: var(--text-sm);">
                                                        Begin with Introduction to DSA</p>
                                                </div>
                                                <svg style="margin-left: auto;" width="20" height="20"
                                                    viewBox="0 0 24 24" fill="none" stroke="var(--text-muted)"
                                                    stroke-width="2">
                                                    <polyline points="9 18 15 12 9 6" />
                                                </svg>
                                            </a>

                                            <%-- What You'll Learn --%>
                                                <div class="card">
                                                    <h3 style="margin: 0 0 var(--space-4) 0;">What You'll Learn</h3>
                                                    <ul
                                                        style="margin: 0; padding-left: var(--space-6); color: var(--text-secondary);">
                                                        <li>Complexity analysis: Big O, time and space complexity</li>
                                                        <li>Arrays, strings, and fundamental operations</li>
                                                        <li>Searching algorithms: linear, binary, and variants</li>
                                                        <li>Sorting algorithms: bubble, merge, quick, heap sort</li>
                                                        <li>Linked lists: singly, doubly, circular</li>
                                                        <li>Stacks, queues, and their applications</li>
                                                        <li>Hash tables, hash maps, and collision handling</li>
                                                        <li>Trees: binary trees, BST, AVL, heaps, tries</li>
                                                        <li>Graphs: BFS, DFS, Dijkstra, MST, topological sort</li>
                                                        <li>Dynamic programming: memoization, tabulation, patterns</li>
                                                        <li>Problem-solving strategies and patterns</li>
                                                    </ul>
                                                </div>

                                                <%-- Course Info --%>
                                                    <div
                                                        style="display: grid; grid-template-columns: repeat(auto-fit, minmax(150px, 1fr)); gap: var(--space-4);">
                                                        <div class="card" style="text-align: center;">
                                                            <div
                                                                style="font-size: var(--text-3xl); font-weight: 700; color: var(--accent-primary);">
                                                                65+</div>
                                                            <div
                                                                style="color: var(--text-muted); font-size: var(--text-sm);">
                                                                Lessons</div>
                                                        </div>
                                                        <div class="card" style="text-align: center;">
                                                            <div
                                                                style="font-size: var(--text-3xl); font-weight: 700; color: var(--accent-primary);">
                                                                13</div>
                                                            <div
                                                                style="color: var(--text-muted); font-size: var(--text-sm);">
                                                                Modules</div>
                                                        </div>
                                                        <div class="card" style="text-align: center;">
                                                            <div
                                                                style="font-size: var(--text-3xl); font-weight: 700; color: var(--accent-primary);">
                                                                50+</div>
                                                            <div
                                                                style="color: var(--text-muted); font-size: var(--text-sm);">
                                                                Visualizations</div>
                                                        </div>
                                                        <div class="card" style="text-align: center;">
                                                            <div
                                                                style="font-size: var(--text-3xl); font-weight: 700; color: var(--success);">
                                                                Free</div>
                                                            <div
                                                                style="color: var(--text-muted); font-size: var(--text-sm);">
                                                                Forever</div>
                                                        </div>
                                                    </div>

                                                    <%-- Course Modules Overview --%>
                                                        <div class="card">
                                                            <h3 style="margin: 0 0 var(--space-4) 0;">Course Modules
                                                            </h3>
                                                            <div
                                                                style="display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: var(--space-3);">
                                                                <div
                                                                    style="padding: var(--space-3); background: var(--bg-secondary); border-radius: var(--radius-md);">
                                                                    <strong style="color: var(--text-primary);">1.
                                                                        Introduction</strong>
                                                                    <p
                                                                        style="margin: var(--space-1) 0 0; font-size: var(--text-sm); color: var(--text-muted);">
                                                                        What is DSA, why it matters</p>
                                                                </div>
                                                                <div
                                                                    style="padding: var(--space-3); background: var(--bg-secondary); border-radius: var(--radius-md);">
                                                                    <strong style="color: var(--text-primary);">2.
                                                                        Complexity Analysis</strong>
                                                                    <p
                                                                        style="margin: var(--space-1) 0 0; font-size: var(--text-sm); color: var(--text-muted);">
                                                                        Big O, time/space complexity</p>
                                                                </div>
                                                                <div
                                                                    style="padding: var(--space-3); background: var(--bg-secondary); border-radius: var(--radius-md);">
                                                                    <strong style="color: var(--text-primary);">3.
                                                                        Arrays & Strings</strong>
                                                                    <p
                                                                        style="margin: var(--space-1) 0 0; font-size: var(--text-sm); color: var(--text-muted);">
                                                                        Two pointers, sliding window</p>
                                                                </div>
                                                                <div
                                                                    style="padding: var(--space-3); background: var(--bg-secondary); border-radius: var(--radius-md);">
                                                                    <strong style="color: var(--text-primary);">4.
                                                                        Searching & Sorting</strong>
                                                                    <p
                                                                        style="margin: var(--space-1) 0 0; font-size: var(--text-sm); color: var(--text-muted);">
                                                                        Binary search, merge sort, quick sort</p>
                                                                </div>
                                                                <div
                                                                    style="padding: var(--space-3); background: var(--bg-secondary); border-radius: var(--radius-md);">
                                                                    <strong style="color: var(--text-primary);">5.
                                                                        Linked Lists</strong>
                                                                    <p
                                                                        style="margin: var(--space-1) 0 0; font-size: var(--text-sm); color: var(--text-muted);">
                                                                        Singly, doubly, circular, reversal</p>
                                                                </div>
                                                                <div
                                                                    style="padding: var(--space-3); background: var(--bg-secondary); border-radius: var(--radius-md);">
                                                                    <strong style="color: var(--text-primary);">6.
                                                                        Stacks & Queues</strong>
                                                                    <p
                                                                        style="margin: var(--space-1) 0 0; font-size: var(--text-sm); color: var(--text-muted);">
                                                                        LIFO, FIFO, applications</p>
                                                                </div>
                                                                <div
                                                                    style="padding: var(--space-3); background: var(--bg-secondary); border-radius: var(--radius-md);">
                                                                    <strong style="color: var(--text-primary);">7.
                                                                        Hashing</strong>
                                                                    <p
                                                                        style="margin: var(--space-1) 0 0; font-size: var(--text-sm); color: var(--text-muted);">
                                                                        Hash tables, maps, sets, collisions</p>
                                                                </div>
                                                                <div
                                                                    style="padding: var(--space-3); background: var(--bg-secondary); border-radius: var(--radius-md);">
                                                                    <strong style="color: var(--text-primary);">8.
                                                                        Trees</strong>
                                                                    <p
                                                                        style="margin: var(--space-1) 0 0; font-size: var(--text-sm); color: var(--text-muted);">
                                                                        Binary tree, BST, traversals</p>
                                                                </div>
                                                                <div
                                                                    style="padding: var(--space-3); background: var(--bg-secondary); border-radius: var(--radius-md);">
                                                                    <strong style="color: var(--text-primary);">9.
                                                                        Advanced Trees</strong>
                                                                    <p
                                                                        style="margin: var(--space-1) 0 0; font-size: var(--text-sm); color: var(--text-muted);">
                                                                        Heaps, tries, priority queues</p>
                                                                </div>
                                                                <div
                                                                    style="padding: var(--space-3); background: var(--bg-secondary); border-radius: var(--radius-md);">
                                                                    <strong style="color: var(--text-primary);">10.
                                                                        Graphs - Part 1</strong>
                                                                    <p
                                                                        style="margin: var(--space-1) 0 0; font-size: var(--text-sm); color: var(--text-muted);">
                                                                        BFS, DFS, topological sort</p>
                                                                </div>
                                                                <div
                                                                    style="padding: var(--space-3); background: var(--bg-secondary); border-radius: var(--radius-md);">
                                                                    <strong style="color: var(--text-primary);">11.
                                                                        Graphs - Part 2</strong>
                                                                    <p
                                                                        style="margin: var(--space-1) 0 0; font-size: var(--text-sm); color: var(--text-muted);">
                                                                        Dijkstra, MST, advanced algorithms</p>
                                                                </div>
                                                                <div
                                                                    style="padding: var(--space-3); background: var(--bg-secondary); border-radius: var(--radius-md);">
                                                                    <strong style="color: var(--text-primary);">12.
                                                                        Dynamic Programming - Part 1</strong>
                                                                    <p
                                                                        style="margin: var(--space-1) 0 0; font-size: var(--text-sm); color: var(--text-muted);">
                                                                        1D, 2D DP, knapsack problems</p>
                                                                </div>
                                                                <div
                                                                    style="padding: var(--space-3); background: var(--bg-secondary); border-radius: var(--radius-md);">
                                                                    <strong style="color: var(--text-primary);">13.
                                                                        Dynamic Programming - Part 2</strong>
                                                                    <p
                                                                        style="margin: var(--space-1) 0 0; font-size: var(--text-sm); color: var(--text-muted);">
                                                                        String DP, tree DP, advanced patterns</p>
                                                                </div>
                                                            </div>
                                                        </div>

                                                        <%-- Why Learn DSA --%>
                                                            <div class="card">
                                                                <h3 style="margin: 0 0 var(--space-4) 0;">Why Learn Data
                                                                    Structures & Algorithms?</h3>
                                                                <div style="display: grid; gap: var(--space-3);">
                                                                    <div style="display: flex; gap: var(--space-3);">
                                                                        <div
                                                                            style="width: 40px; height: 40px; background: var(--accent-light); border-radius: var(--radius-md); display: flex; align-items: center; justify-content: center; flex-shrink: 0;">
                                                                            <svg width="20" height="20"
                                                                                viewBox="0 0 24 24" fill="none"
                                                                                stroke="var(--accent-primary)"
                                                                                stroke-width="2">
                                                                                <path
                                                                                    d="M22 11.08V12a10 10 0 1 1-5.93-9.14" />
                                                                                <polyline
                                                                                    points="22 4 12 14.01 9 11.01" />
                                                                            </svg>
                                                                        </div>
                                                                        <div>
                                                                            <strong
                                                                                style="color: var(--text-primary);">Ace
                                                                                Technical Interviews</strong>
                                                                            <p
                                                                                style="margin: var(--space-1) 0 0; color: var(--text-secondary); font-size: var(--text-sm);">
                                                                                Master the skills tested by top tech
                                                                                companies like Google, Amazon,
                                                                                Microsoft, and Facebook.</p>
                                                                        </div>
                                                                    </div>
                                                                    <div style="display: flex; gap: var(--space-3);">
                                                                        <div
                                                                            style="width: 40px; height: 40px; background: var(--success-light); border-radius: var(--radius-md); display: flex; align-items: center; justify-content: center; flex-shrink: 0;">
                                                                            <svg width="20" height="20"
                                                                                viewBox="0 0 24 24" fill="none"
                                                                                stroke="var(--success)"
                                                                                stroke-width="2">
                                                                                <polyline
                                                                                    points="22 12 18 12 15 21 9 3 6 12 2 12" />
                                                                            </svg>
                                                                        </div>
                                                                        <div>
                                                                            <strong
                                                                                style="color: var(--text-primary);">Write
                                                                                Efficient Code</strong>
                                                                            <p
                                                                                style="margin: var(--space-1) 0 0; color: var(--text-secondary); font-size: var(--text-sm);">
                                                                                Learn to optimize your code for better
                                                                                performance and scalability in
                                                                                production systems.</p>
                                                                        </div>
                                                                    </div>
                                                                    <div style="display: flex; gap: var(--space-3);">
                                                                        <div
                                                                            style="width: 40px; height: 40px; background: var(--warning-light); border-radius: var(--radius-md); display: flex; align-items: center; justify-content: center; flex-shrink: 0;">
                                                                            <svg width="20" height="20"
                                                                                viewBox="0 0 24 24" fill="none"
                                                                                stroke="var(--warning)"
                                                                                stroke-width="2">
                                                                                <circle cx="12" cy="12" r="10" />
                                                                                <polyline points="12 6 12 12 16 14" />
                                                                            </svg>
                                                                        </div>
                                                                        <div>
                                                                            <strong
                                                                                style="color: var(--text-primary);">Solve
                                                                                Real Problems</strong>
                                                                            <p
                                                                                style="margin: var(--space-1) 0 0; color: var(--text-secondary); font-size: var(--text-sm);">
                                                                                Apply algorithms to real-world scenarios
                                                                                like route planning, recommendation
                                                                                systems, and data analysis.</p>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </div>
                                    </div>
                                </div>
                            </article>
                    </main>

                    <%@ include file="../tutorial-footer.jsp" %>
            </div>

            <script src="<%=request.getContextPath()%>/tutorials/assets/js/progress.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/tutorial-core.js?v=4"></script>
        </body>

        </html>