<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "advanced-synchronization" );
        request.setAttribute("currentModule", "Advanced Topics" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Java Synchronization - Java Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Learn about Synchronization in Java Multithreading. Prevent race conditions and ensure thread safety with the synchronized keyword.">
            <meta name="keywords"
                content="java synchronization, synchronized keyword, thread safety, race condition java, intrinsic lock">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Java Synchronization - Java Tutorial | 8gwifi.org">
            <meta property="og:description" content="Master the art of thread safety with Java Synchronization.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/java/advanced-synchronization.jsp">
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
    "name": "Java Synchronization",
    "description": "Guide to Synchronization in Java.",
    "learningResourceType": "tutorial",
    "educationalLevel": "Advanced",
    "teaches": ["Race Condition", "Synchronized Methods", "Thread Safety"],
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

        <body class="tutorial-body no-preview" data-lesson="advanced-synchronization">
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
                                    <span>Synchronization</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Synchronization</h1>
                                    <div class="lesson-meta">
                                        <span>Advanced</span>
                                        <span>~20 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead"><strong>Synchronization</strong> is the capability to control the
                                        access of multiple threads to any shared resource. It is used to prevent thread
                                        interference and consistency inconsistencies.</p>

                                    <!-- Section 1: Race Conditions -->
                                    <h2>Race Conditions</h2>
                                    <p>A race condition occurs when two or more threads attempt to change shared data at
                                        the same time. This leads to unpredictable and incorrect results.</p>
                                    <p>Example: Two threads trying to increment a counter <code>count++</code> at the
                                        same time. The result might be 1 instead of 2!</p>

                                    <!-- Section 2: The synchronized Keyword -->
                                    <h2>The <code>synchronized</code> Keyword</h2>
                                    <p>You can use the <code>synchronized</code> keyword to ensure that only
                                        <strong>one</strong> thread can access a resource at a time.</p>

                                    <h3>1. Synchronized Method</h3>
                                    <pre><code class="language-java">public synchronized void increment() {
    count++;
}</code></pre>

                                    <h3>2. Synchronized Block</h3>
                                    <p>More granular control. You lock only a specific part of the code.</p>
                                    <pre><code class="language-java">public void increment() {
    synchronized(this) {
        count++;
    }
}</code></pre>

                                    <!-- Section 3: Example -->
                                    <h2>Full Example</h2>
                                    <p>This example demonstrates what happens without synchronization (commented out)
                                        and with synchronization.</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="java/SyncExample.java" />
                                        <jsp:param name="language" value="java" />
                                        <jsp:param name="editorId" value="compiler-sync" />
                                    </jsp:include>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>Race Conditions</strong> ruin data integrity.</li>
                                            <li><strong>Synchronized</strong> ensures only one thread executes a
                                                block/method at a time.</li>
                                            <li>This comes at a performance cost, so use it only when sharing resources.
                                            </li>
                                        </ul>
                                    </div>

                                    <div style="margin-top: 3rem;">
                                        <% String prevLinkUrl=request.getContextPath()
                                            + "/tutorials/java/advanced-threading.jsp" ; String
                                            nextLinkUrl=request.getContextPath()
                                            + "/tutorials/java/advanced-executors.jsp" ; %>
                                            <jsp:include page="../tutorial-nav.jsp">
                                                <jsp:param name="prevLink" value="<%=prevLinkUrl%>" />
                                                <jsp:param name="prevTitle" value="Threading Basics" />
                                                <jsp:param name="nextLink" value="<%=nextLinkUrl%>" />
                                                <jsp:param name="nextTitle" value="Concurrency Utilities →" />
                                                <jsp:param name="currentLessonId" value="advanced-synchronization" />
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