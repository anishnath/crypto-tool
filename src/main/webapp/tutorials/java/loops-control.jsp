<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "loops-control" ); request.setAttribute("currentModule", "Control Flow" );
        %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Java Break and Continue - Java Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Learn how to control loop execution in Java using break and continue statements. Guide to exiting loops early or skipping iterations.">
            <meta name="keywords"
                content="java break statement, java continue statement, java loop control, java break vs continue, java labeled loops">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Java Loop Control (Break & Continue) - Java Tutorial | 8gwifi.org">
            <meta property="og:description"
                content="Master loop control in Java. Learn when and how to use break and continue keywords effectively.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/java/loops-control.jsp">
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
    "name": "Java Break and Continue",
    "description": "Guide to using break and continue statements in Java loops.",
    "learningResourceType": "tutorial",
    "educationalLevel": "Beginner",
    "teaches": ["Break Statement", "Continue Statement", "Labeled Loops"],
    "timeRequired": "PT10M",
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

        <body class="tutorial-body no-preview" data-lesson="loops-control">
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
                                    <span>Loop Control</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Break and Continue</h1>
                                    <div class="lesson-meta">
                                        <span>Beginner</span>
                                        <span>~10 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">Sometimes you need to fine-tune loop execution. You might want to
                                        stop the loop entirely based on a dynamic condition, or just skip the current
                                        iteration.</p>

                                    <!-- Section 1: Break -->
                                    <h2>The <code>break</code> Statement</h2>
                                    <p>The <code>break</code> statement causes the loop to <strong>terminate
                                            immediately</strong>. Control is transferred to the statement following the
                                        loop.</p>
                                    <p>Commonly used when searching for an item; once found, there is no need to keep
                                        searching.</p>

                                    <div class="code-box">
                                        <pre><code class="language-java">for (int i = 0; i < 10; i++) {
    if (i == 4) {
        break; // Stop loop completely when i is 4
    }
    System.out.println(i);
}</code></pre>
                                    </div>

                                    <!-- Section 2: Continue -->
                                    <h2>The <code>continue</code> Statement</h2>
                                    <p>The <code>continue</code> statement skips the <strong>rest of the current
                                            iteration</strong> and jumps back to the loop update/condition check. The
                                        loop itself continues to run.</p>
                                    <p>Commonly used to filter out invalid items.</p>

                                    <div class="code-box">
                                        <pre><code class="language-java">for (int i = 0; i < 5; i++) {
    if (i == 2) {
        continue; // Skip 2, but go on to 3
    }
    System.out.println(i);
}</code></pre>
                                    </div>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="java/loops-control.java" />
                                        <jsp:param name="language" value="java" />
                                        <jsp:param name="editorId" value="compiler-control" />
                                    </jsp:include>

                                    <!-- Section 3: Labeled Break (Advanced) -->
                                    <h2>Labeled Loops (Nested Loops)</h2>
                                    <p>By default, <code>break</code> only exits the <em>innermost</em> loop. If you
                                        want to break out of nested loops (e.g., stopping a matrix search), you can use
                                        a <strong>label</strong>.</p>
                                    <pre><code class="language-java">search: // This is a label
for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
        if (arr[i][j] == target) {
            break search; // Exits BOTH loops
        }
    }
}</code></pre>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><code>break</code> stops the loop entirely.</li>
                                            <li><code>continue</code> skips the current iteration and goes to the next
                                                one.</li>
                                            <li>Use <strong>labels</strong> to control nested loops from the inside.
                                            </li>
                                        </ul>
                                    </div>

                                    <div style="margin-top: 3rem;">
                                        <% String prevLinkUrl=request.getContextPath()
                                            + "/tutorials/java/loops-while.jsp" ; // Next module is Methods (Module 5)
                                            String nextLinkUrl=request.getContextPath()
                                            + "/tutorials/java/methods-basics.jsp" ; %>
                                            <jsp:include page="../tutorial-nav.jsp">
                                                <jsp:param name="prevLink" value="<%=prevLinkUrl%>" />
                                                <jsp:param name="prevTitle" value="While Loops" />
                                                <jsp:param name="nextLink" value="<%=nextLinkUrl%>" />
                                                <jsp:param name="nextTitle" value="Methods Basics (Next Module) →" />
                                                <jsp:param name="currentLessonId" value="loops-control" />
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