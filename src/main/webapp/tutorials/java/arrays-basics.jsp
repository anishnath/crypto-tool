<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "arrays-basics" );
        request.setAttribute("currentModule", "Variables & Data Types" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Java Arrays: Declaration, Initialization & Basics - Java Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Learn the basics of Java Arrays. How to declare, initialize, loop through, and access array elements in Java.">
            <meta name="keywords"
                content="java arrays, array declaration, java array initialization, java array length, array loop java, java data structures">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Java Arrays: Declaration & Initialization - Java Tutorial | 8gwifi.org">
            <meta property="og:description"
                content="Master Java Arrays: The fundamental data structure for storing collections of data.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/java/arrays-basics.jsp">
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
        "name": "Java Arrays Basics",
        "description": "Introduction to Java Arrays, declaration, and usage.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Beginner",
        "teaches": ["Array declaration", "Array initialization", "Looping arrays", "Array IndexOutOfBounds"],
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

        <body class="tutorial-body no-preview" data-lesson="arrays-basics">
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
                                    <span>Arrays</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Java Arrays</h1>
                                    <div class="lesson-meta">
                                        <span>Beginner</span>
                                        <span>~25 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">An array is a container object that holds a fixed number of values
                                        of a single type. Unlike variables that hold just one value, an array can hold
                                        dozens, hundreds, or even thousands of values under a single name.</p>

                                    <!-- Section 1: Anatomy of an Array -->
                                    <h2>Anatomy of an Array</h2>
                                    <p>Think of an array as a row of mailboxes. Each mailbox has an index number, and
                                        you can put data inside each one.</p>
                                    <ul>
                                        <li><strong>Fixed Size:</strong> Once created, you cannot change the size of an
                                            array.</li>
                                        <li><strong>Same Type:</strong> All elements must be of the same data type
                                            (e.g., all <code>int</code>).</li>
                                        <li><strong>Zero-Indexed:</strong> The first element is at index 0, not 1.</li>
                                    </ul>

                                    <img src="<%=request.getContextPath()%>/tutorials/assets/images/java-array-structure.svg"
                                        alt="Java Array Structure Diagram" class="diagram-image"
                                        style="max-width: 800px; margin: 2rem auto; display: block;">

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="java/arrays-basics.java" />
                                        <jsp:param name="language" value="java" />
                                        <jsp:param name="editorId" value="compiler-arrays" />
                                    </jsp:include>

                                    <div class="mistake-box">
                                        <h4>ArrayIndexOutOfBoundsException</h4>
                                        <p>This is the most common error with arrays. If an array has a size of 5, valid
                                            indices are 0, 1, 2, 3, 4. accessing <code>arr[5]</code> will crash your
                                            program!</p>
                                    </div>

                                    <!-- Section 2: Initialization Ways -->
                                    <h2>Ways to Initialize Arrays</h2>
                                    <p>There are a few different ways to create and fill arrays, depending on whether
                                        you know the values upfront or just the size.</p>

                                    <pre><code class="language-java">// 1. Size only (Default values: 0, null, false)
int[] nums = new int[5];

// 2. Values directly (Array Literal)
String[] names = {"Alice", "Bob", "Charlie"};</code></pre>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="java/arrays-initialization.java" />
                                        <jsp:param name="language" value="java" />
                                        <jsp:param name="editorId" value="compiler-init" />
                                    </jsp:include>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <!-- Section 3: Looping Through Arrays -->
                                    <h2>Looping Through Arrays</h2>
                                    <p>To process all elements in an array, we typically use a <code>for</code> loop.
                                    </p>
                                    <pre><code class="language-java">int[] scores = {10, 20, 30};

// Standard For Loop
for (int i = 0; i < scores.length; i++) {
    System.out.println(scores[i]);
}

// Enhanced For-Each Loop (Clean & Readable)
for (int score : scores) {
    System.out.println(score);
}</code></pre>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li>Arrays store multiple values of the <strong>same type</strong> in a
                                                contiguous memory block.</li>
                                            <li>Arrays have a <strong>fixed size</strong> that cannot be changed.</li>
                                            <li>Array indices start at <strong>0</strong>.</li>
                                            <li>Use <code>array.length</code> to find out how many items an array can
                                                hold.</li>
                                        </ul>
                                    </div>

                                    <!-- What's Next -->
                                    <h2>What's Next?</h2>
                                    <p>You've mastered single-dimensional arrays. But what if you need a grid, a matrix,
                                        or a table of data? That's where <strong>Multi-dimensional Arrays</strong> come
                                        in. Let's explore 2D arrays in the next lesson.</p>

                                    <div style="margin-top: 3rem;">
                                        <% String nextLinkUrl=request.getContextPath()
                                            + "/tutorials/java/arrays-multidimensional.jsp" ; String
                                            prevLinkUrl=request.getContextPath() + "/tutorials/java/strings-basics.jsp"
                                            ; %>
                                            <jsp:include page="../tutorial-nav.jsp">
                                                <jsp:param name="prevLink" value="<%=prevLinkUrl%>" />
                                                <jsp:param name="prevTitle" value="Strings" />
                                                <jsp:param name="nextLink" value="<%=nextLinkUrl%>" />
                                                <jsp:param name="nextTitle" value="2D Arrays →" />
                                                <jsp:param name="currentLessonId" value="arrays-basics" />
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