<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "arrays-multidimensional" );
        request.setAttribute("currentModule", "Variables & Data Types" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Java Multi-Dimensional Arrays (2D Arrays) - Java Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Learn how to work with Multi-dimensional Arrays in Java. Understand 2D arrays (Matrices), how to iterate over them, and the concept of jagged arrays.">
            <meta name="keywords"
                content="java 2d array, java multidimensional array, java matrix, java jagged array, nested loops java">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Java Multi-Dimensional Arrays - Java Tutorial | 8gwifi.org">
            <meta property="og:description"
                content="Master Java 2D Arrays and Matrices: Storing data in rows and columns.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/java/arrays-multidimensional.jsp">
            <link rel="icon" type="image/svg+xml"
                href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial-server.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror.min.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/monokai.min.css">

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
        "name": "Java Multi-Dimensional Arrays",
        "description": "Learn about 2D arrays and jagged arrays in Java.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Beginner",
        "teaches": ["2D Arrays", "Matrix operations", "Nested Arrays", "Jagged Arrays"],
        "timeRequired": "PT25M",
        "isPartOf": {
            "@type": "Course",
            "name": "Java Tutorial",
            "url": "https://8gwifi.org/tutorials/java/"
        }
    }
    </script>

            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="arrays-multidimensional">
            <div class="tutorial-layout">
                <%@ include file="../tutorial-header.jsp" %>

                    <main class="tutorial-main">
                        <%@ include file="../tutorial-sidebar-java.jsp" %>
                            <div class="overlay" id="sidebarOverlay" onclick="toggleSidebar()"></div>

                            <article class="tutorial-content">
                                <nav class="breadcrumb">
                                    <a href="<%=request.getContextPath()%>/tutorials/">Tutorials</a>
                                    <span class="breadcrumb-separator">/</span>
                                    <a href="<%=request.getContextPath()%>/tutorials/java/">Java</a>
                                    <span class="breadcrumb-separator">/</span>
                                    <span>Multi-Dimensional Arrays</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Multi-Dimensional Arrays</h1>
                                    <div class="lesson-meta">
                                        <span>Beginner</span>
                                        <span>~25 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">A multi-dimensional array is essentially an "array of arrays." The
                                        most common type is the <strong>2D array</strong>, which represents a table or
                                        matrix with rows and columns. You can think of it like an Excel spreadsheet or a
                                        chessboard.</p>

                                    <!-- Section 1: 2D Arrays -->
                                    <h2>2D Arrays (Matrices)</h2>
                                    <p>To declare a 2D array, we use two sets of brackets <code>[][]</code>. The first
                                        bracket represents rows, and the second represents columns.</p>

                                    <img src="<%=request.getContextPath()%>/tutorials/assets/images/java-2d-array.svg"
                                        alt="Java 2D Array Matrix Diagram" class="diagram-image"
                                        style="max-width: 800px; margin: 2rem auto; display: block;">

                                    <pre><code class="language-java">// Syntax: int[][] matrix = new int[rows][cols];
int[][] matrix = new int[3][3]; // A 3x3 table</code></pre>

                                    <!-- Section 2: Accessing Elements -->
                                    <h2>Accessing Elements</h2>
                                    <p>You access elements by specifying the row index first, then the column index.</p>
                                    <pre><code class="language-java">matrix[0][0] = 1;  // Top-left
matrix[1][2] = 5;  // Middle-right</code></pre>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="java/arrays-multidimensional.java" />
                                        <jsp:param name="language" value="java" />
                                        <jsp:param name="editorId" value="compiler-2d" />
                                    </jsp:include>

                                    <!-- Section 3: Jagged Arrays -->
                                    <h2>Jagged Arrays</h2>
                                    <p>Since a 2D array is just an array of arrays, each "row" can actually be a
                                        different length! These are called <strong>ragged</strong> or <strong>jagged
                                            arrays</strong>.</p>

                                    <pre><code class="language-java">int[][] jagged = new int[3][]; // Define 3 rows, but cols unknown
jagged[0] = new int[2]; // Row 0 has 2 cols
jagged[1] = new int[4]; // Row 1 has 4 cols
jagged[2] = new int[1]; // Row 2 has 1 col</code></pre>

                                    <div class="info-box">
                                        <strong>Use Case:</strong> Jagged arrays are memory efficient if you have data
                                        rows of varying sizes (e.g., storing varying number of comments for different
                                        posts).
                                    </div>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li>Use <code>[][]</code> to declare a 2D array.</li>
                                            <li>Think of it as <code>array[rowIndex][colIndex]</code>.</li>
                                            <li>Use nested loops to iterate over all elements.</li>
                                            <li>Rows in a 2D array can have different lengths (Jagged Arrays).</li>
                                        </ul>
                                    </div>

                                    <!-- What's Next -->
                                    <h2>Module Complete!</h2>
                                    <p>Congratulations! You have completed Module 2: Variables & Data Types. You now
                                        have a solid understanding of primitives, strings, arrays, and how to store data
                                        in Java.</p>
                                    <p>In the next module, we will bring your programs to life with <strong>Operators &
                                            Control Flow</strong> (If statements, loops, logic).</p>

                                    <div style="margin-top: 3rem;">
                                        <% String nextLinkUrl=request.getContextPath()
                                            + "/tutorials/java/operators-arithmetic.jsp" ; String
                                            prevLinkUrl=request.getContextPath() + "/tutorials/java/arrays-basics.jsp" ;
                                            %>
                                            <jsp:include page="../tutorial-nav.jsp">
                                                <jsp:param name="prevLink" value="<%=prevLinkUrl%>" />
                                                <jsp:param name="prevTitle" value="Arrays" />
                                                <jsp:param name="nextLink" value="<%=nextLinkUrl%>" />
                                                <jsp:param name="nextTitle" value="Next Module: Operators →" />
                                                <jsp:param name="currentLessonId" value="arrays-multidimensional" />
                                            </jsp:include>
                                    </div>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>
                            </article>
                    </main>

                    <%@ include file="../tutorial-footer.jsp" %>
            </div>

            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/clike.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/progress.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/tutorial-core.js?v=4"></script>
        </body>

        </html>