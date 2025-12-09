<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "advanced-executors" );
        request.setAttribute("currentModule", "Advanced Topics" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Java Concurrency Utilities - Java Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Learn about Java Concurrency Utilities. Use ExecutorService, Thread Pools, and Callable for advanced multithreading.">
            <meta name="keywords"
                content="java executorservice, java thread pool, callable vs runnable, java concurrency, future java">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Java Concurrency Utilities - Java Tutorial | 8gwifi.org">
            <meta property="og:description" content="Simplify multithreading with Java's Executor Framework.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/java/advanced-executors.jsp">
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
    "name": "Java Concurrency Utilities",
    "description": "Guide to ExecutorService and Thread Pools.",
    "learningResourceType": "tutorial",
    "educationalLevel": "Advanced",
    "teaches": ["ExecutorService", "Thread Pools", "Callable and Future"],
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

        <body class="tutorial-body no-preview" data-lesson="advanced-executors">
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
                                    <span>Concurrency Utilities</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Concurrency Utilities</h1>
                                    <div class="lesson-meta">
                                        <span>Advanced</span>
                                        <span>~25 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">Creating and managing threads manually is difficult and error-prone.
                                        The <strong>Executor Framework</strong> (introduced in Java 5) separates task
                                        creation from execution.</p>

                                    <!-- Section 1: ExecutorService -->
                                    <h2>ExecutorService</h2>
                                    <p>Instead of <code>new Thread(task).start()</code>, you use an Executor to run
                                        tasks.</p>
                                    <pre><code class="language-java">ExecutorService executor = Executors.newFixedThreadPool(10);
executor.execute(new RunnableTask());
executor.shutdown();</code></pre>

                                    <!-- Section 2: Thread Pools -->
                                    <h2>Thread Pools</h2>
                                    <p>Creating a new thread is expensive. A <strong>Thread Pool</strong> reuses a fixed
                                        number of threads to execute many tasks.</p>
                                    <ul>
                                        <li><code>newFixedThreadPool(n)</code>: Reuses a fixed set of threads.</li>
                                        <li><code>newCachedThreadPool()</code>: Creates new threads as needed, but
                                            reuses them if available.</li>
                                    </ul>

                                    <!-- Section 3: Callable and Future -->
                                    <h2>Callable vs Runnable</h2>
                                    <p><code>Runnable</code> doesn't return a value. <code>Callable</code> does!</p>
                                    <pre><code class="language-java">Future&lt;Integer&gt; future = executor.submit(callableTask);
Integer result = future.get(); // Blocks until result is ready</code></pre>

                                    <!-- Section 4: Example -->
                                    <h2>Full Example</h2>
                                    <p>We will create a pool of 2 threads to execute 5 tasks.</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="java/ExecutorExample.java" />
                                        <jsp:param name="language" value="java" />
                                        <jsp:param name="editorId" value="compiler-executors" />
                                    </jsp:include>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li>Use <strong>ExecutorService</strong> instead of managing threads
                                                manually.</li>
                                            <li>Use <strong>Callable</strong> if you need a result from the thread.</li>
                                            <li>Always call <code>shutdown()</code> to stop the executor.</li>
                                        </ul>
                                    </div>

                                    <div style="margin-top: 3rem;">
                                        <% String prevLinkUrl=request.getContextPath()
                                            + "/tutorials/java/advanced-synchronization.jsp" ; String
                                            nextLinkUrl=request.getContextPath() + "/tutorials/java/advanced-enums.jsp"
                                            ; %>
                                            <jsp:include page="../tutorial-nav.jsp">
                                                <jsp:param name="prevLink" value="<%=prevLinkUrl%>" />
                                                <jsp:param name="prevTitle" value="Synchronization" />
                                                <jsp:param name="nextLink" value="<%=nextLinkUrl%>" />
                                                <jsp:param name="nextTitle" value="Enums →" />
                                                <jsp:param name="currentLessonId" value="advanced-executors" />
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