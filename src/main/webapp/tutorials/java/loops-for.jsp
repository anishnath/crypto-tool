<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "loops-for" ); request.setAttribute("currentModule", "Control Flow" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Java For Loops - Java Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Learn how to use Java For Loops for iteration. Covers standard for loops and the enhanced for-each loop for arrays and collections.">
            <meta name="keywords"
                content="java for loop, java enhanced for loop, java foreach loop, java iteration, java loop structures">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Java For Loops - Java Tutorial | 8gwifi.org">
            <meta property="og:description"
                content="Master iteration in Java. Learn the syntax and flow of for loops and for-each loops.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/java/loops-for.jsp">
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
    "name": "Java For Loops",
    "description": "Guide to Java for loops and enhanced for loops.",
    "learningResourceType": "tutorial",
    "educationalLevel": "Beginner",
    "teaches": ["For Loop Syntax", "Loop Initialization", "Loop Condition", "Loop Update", "Enhanced For-Each Loop"],
    "timeRequired": "PT20M",
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

        <body class="tutorial-body no-preview" data-lesson="loops-for">
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
                                    <span>For Loops</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">For Loops</h1>
                                    <div class="lesson-meta">
                                        <span>Beginner</span>
                                        <span>~20 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">Loops allow you to execute a block of code multiple times. The
                                        <code>for</code> loop is commonly used when you know exactly how many times you
                                        want to loop.</p>

                                    <!-- Section 1: Standard For Loop -->
                                    <h2>Standard For Loop</h2>
                                    <div class="code-box">
                                        <pre><code class="language-java">for (initialization; condition; update) {
    // Code to be executed
}</code></pre>
                                    </div>

                                    <p>The loop has three parts:</p>
                                    <ol>
                                        <li><strong>Initialization:</strong> Runs once before the loop starts (e.g.,
                                            <code>int i = 0</code>).</li>
                                        <li><strong>Condition:</strong> Checked before every iteration. If true, the
                                            loop runs. If false, it stops.</li>
                                        <li><strong>Update:</strong> Runs after every iteration (e.g.,
                                            <code>i++</code>).</li>
                                    </ol>

                                    <img src="<%=request.getContextPath()%>/tutorials/assets/images/java-flow-for.svg"
                                        alt="Java For Loop Lifecycle" class="diagram-image"
                                        style="max-width: 600px; margin: 2rem auto; display: block;">

                                    <!-- Section 2: Enhanced For Loop -->
                                    <h2>Enhanced For-Each Loop</h2>
                                    <p>Introduced in Java 5, the "for-each" loop is used exclusively to loop through
                                        elements in an <strong>array</strong> or a <strong>collection</strong>.</p>

                                    <pre><code class="language-java">String[] cars = {"Volvo", "BMW", "Ford"};
for (String car : cars) {
    System.out.println(car);
}</code></pre>

                                    <div class="tip-box">
                                        <strong>Why use it?</strong> It's cleaner and less error-prone (no risk of
                                        Off-By-One errors with index). Use it whenever you need to read all elements of
                                        a collection.
                                    </div>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="java/ForLoops.java" />
                                        <jsp:param name="language" value="java" />
                                        <jsp:param name="editorId" value="compiler-for" />
                                    </jsp:include>

                                    <!-- Section 3: Nested Loops -->
                                    <h2>Nested Loops</h2>
                                    <p>Is exactly what it sounds like: a loop inside a loop. This is common when working
                                        with 2D arrays (matrices).</p>
                                    <pre><code class="language-java">// Outer loop
for (int i = 1; i <= 3; i++) {
    // Inner loop
    for (int j = 1; j <= 3; j++) {
        System.out.println(i + " " + j);
    }
}</code></pre>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li>Use <code>for</code> loops when you know the number of iterations.</li>
                                            <li>Use the enhanced <code>for-each</code> loop for iterating over arrays
                                                and collections.</li>
                                            <li>Be careful with infinite loops (if the condition never becomes false).
                                            </li>
                                        </ul>
                                    </div>

                                    <div style="margin-top: 3rem;">
                                        <% String prevLinkUrl=request.getContextPath()
                                            + "/tutorials/java/control-switch.jsp" ; String
                                            nextLinkUrl=request.getContextPath() + "/tutorials/java/loops-while.jsp" ;
                                            %>
                                            <jsp:include page="../tutorial-nav.jsp">
                                                <jsp:param name="prevLink" value="<%=prevLinkUrl%>" />
                                                <jsp:param name="prevTitle" value="Switch Statements" />
                                                <jsp:param name="nextLink" value="<%=nextLinkUrl%>" />
                                                <jsp:param name="nextTitle" value="While Loops →" />
                                                <jsp:param name="currentLessonId" value="loops-for" />
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