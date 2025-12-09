<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "loops-while" ); request.setAttribute("currentModule", "Control Flow" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Java While and Do-While Loops - Java Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Learn the difference between While and Do-While loops in Java. Understand pre-test vs post-test loops with clear examples.">
            <meta name="keywords"
                content="java while loop, java do while loop, java infinite loop, java loop condition, java control flow">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Java While Loops - Java Tutorial | 8gwifi.org">
            <meta property="og:description" content="Master indeterminate iteration with While and Do-While loops.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/java/loops-while.jsp">
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
    "name": "Java While Loops",
    "description": "Guide to using while and do-while loops in Java.",
    "learningResourceType": "tutorial",
    "educationalLevel": "Beginner",
    "teaches": ["While Loop", "Do-While Loop", "Indeterminate Iteration"],
    "timeRequired": "PT15M",
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

        <body class="tutorial-body no-preview" data-lesson="loops-while">
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
                                    <span>While Loops</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">While & Do-While Loops</h1>
                                    <div class="lesson-meta">
                                        <span>Beginner</span>
                                        <span>~15 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">While <code>for</code> loops are great when you know the number of
                                        iterations, <code>while</code> loops are perfect when you want to loop
                                        <strong>until a condition changes</strong>.</p>

                                    <!-- Section 1: While Loop -->
                                    <h2>The <code>while</code> Loop</h2>
                                    <p>It checks the condition <strong>before</strong> entering the loop block. If the
                                        condition is false initially, the code never runs.</p>

                                    <div class="code-box">
                                        <pre><code class="language-java">while (condition) {
    // Code to execute
    // Update variables
}</code></pre>
                                    </div>

                                    <!-- Section 2: Do-While Loop -->
                                    <h2>The <code>do-while</code> Loop</h2>
                                    <p>It checks the condition <strong>after</strong> executing the block. This
                                        guarantees the code runs <strong>at least once</strong>.</p>

                                    <div class="code-box">
                                        <pre><code class="language-java">do {
    // Code to execute
} while (condition);</code></pre>
                                    </div>

                                    <div class="info-box">
                                        <strong>Use Case:</strong> Use <code>do-while</code> for user menus (display
                                        menu, get choice, repeat if invalid). You always want to show the menu at least
                                        once.
                                    </div>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="java/WhileLoops.java" />
                                        <jsp:param name="language" value="java" />
                                        <jsp:param name="editorId" value="compiler-while" />
                                    </jsp:include>

                                    <!-- Section 3: Infinite Loops -->
                                    <h2>The Infinite Loop Trap</h2>
                                    <p>If you forget to update the condition variable inside the loop, it might never
                                        end!</p>
                                    <pre><code class="language-java">int i = 0;
while (i < 5) {
    System.out.println(i);
    // Missing i++ here! Loop runs forever.
}</code></pre>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>While Loop:</strong> Checks condition first. Might run 0 times.
                                            </li>
                                            <li><strong>Do-While Loop:</strong> Checks condition last. Runs at least 1
                                                time.</li>
                                            <li>Always ensure your loop has a way to exit (avoid infinite loops).</li>
                                        </ul>
                                    </div>

                                    <div style="margin-top: 3rem;">
                                        <% String prevLinkUrl=request.getContextPath() + "/tutorials/java/loops-for.jsp"
                                            ; String nextLinkUrl=request.getContextPath()
                                            + "/tutorials/java/loops-control.jsp" ; %>
                                            <jsp:include page="../tutorial-nav.jsp">
                                                <jsp:param name="prevLink" value="<%=prevLinkUrl%>" />
                                                <jsp:param name="prevTitle" value="For Loops" />
                                                <jsp:param name="nextLink" value="<%=nextLinkUrl%>" />
                                                <jsp:param name="nextTitle" value="Loop Control →" />
                                                <jsp:param name="currentLessonId" value="loops-while" />
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