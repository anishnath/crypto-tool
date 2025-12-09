<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "advanced-threading" );
        request.setAttribute("currentModule", "Advanced Topics" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Java Threading Basics - Java Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Learn the basics of Multithreading in Java. Understand how to create threads using the Thread class and Runnable interface, and the lifecycle of a thread.">
            <meta name="keywords"
                content="java multithreading, java threads, extends thread, implements runnable, java thread lifecycle">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Java Threading Basics - Java Tutorial | 8gwifi.org">
            <meta property="og:description" content="Master the basics of creating and managing threads in Java.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/java/advanced-threading.jsp">
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
    "name": "Java Threading Basics",
    "description": "Introduction to Multithreading in Java.",
    "learningResourceType": "tutorial",
    "educationalLevel": "Advanced",
    "teaches": ["Creating Threads", "Runnable Interface", "Thread Lifecycle"],
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

        <body class="tutorial-body no-preview" data-lesson="advanced-threading">
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
                                    <span>Threading</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Threading Basics</h1>
                                    <div class="lesson-meta">
                                        <span>Advanced</span>
                                        <span>~20 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead"><strong>Multithreading</strong> allows concurrent execution of two
                                        or more parts of a program for maximum utilization of CPU. Each part of such
                                        program is called a <strong>Thread</strong>.</p>

                                    <!-- Section 1: Creation -->
                                    <h2>Creating a Thread</h2>
                                    <p>There are two main ways to create a thread in Java:</p>

                                    <h3>1. Extend Thread Class</h3>
                                    <pre><code class="language-java">class MyThread extends Thread {
    public void run() {
        System.out.println("Thread running");
    }
}
// Start it:
MyThread t = new MyThread();
t.start();</code></pre>

                                    <h3>2. Implement Runnable Interface (Preferred)</h3>
                                    <p>Better because you can still extend another class.</p>
                                    <pre><code class="language-java">class MyRunnable implements Runnable {
    public void run() {
        System.out.println("Thread running");
    }
}
// Start it:
Thread t = new Thread(new MyRunnable());
t.start();</code></pre>

                                    <!-- Section 2: Lifecycle -->
                                    <h2>Thread Lifecycle</h2>
                                    <p>A thread goes through various states: <strong>New, Runnable, Running,
                                            Blocked/Waiting, Terminated</strong>.</p>

                                    <img src="<%=request.getContextPath()%>/tutorials/assets/images/java-thread-lifecycle.svg"
                                        alt="Java Thread Lifecycle Diagram" class="diagram-image"
                                        style="max-width: 600px; margin: 2rem auto; display: block;">

                                    <!-- Section 3: Example -->
                                    <h2>Full Example</h2>
                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="java/ThreadExample.java" />
                                        <jsp:param name="language" value="java" />
                                        <jsp:param name="editorId" value="compiler-threading" />
                                    </jsp:include>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li>Use <code>start()</code> to execute the <code>run()</code> method in a
                                                separate thread.</li>
                                            <li>Directly calling <code>run()</code> does not start a new thread.</li>
                                            <li><strong>Runnable</strong> is generally preferred over extending Thread.
                                            </li>
                                        </ul>
                                    </div>

                                    <div style="margin-top: 3rem;">
                                        <% String prevLinkUrl=request.getContextPath()
                                            + "/tutorials/java/advanced-streams.jsp" ; String
                                            nextLinkUrl=request.getContextPath()
                                            + "/tutorials/java/advanced-synchronization.jsp" ; %>
                                            <jsp:include page="../tutorial-nav.jsp">
                                                <jsp:param name="prevLink" value="<%=prevLinkUrl%>" />
                                                <jsp:param name="prevTitle" value="Streams API" />
                                                <jsp:param name="nextLink" value="<%=nextLinkUrl%>" />
                                                <jsp:param name="nextTitle" value="Synchronization →" />
                                                <jsp:param name="currentLessonId" value="advanced-threading" />
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