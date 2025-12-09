<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "exceptions-finally" );
        request.setAttribute("currentModule", "Exception Handling" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Java Finally Block - Java Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Learn how to use the finally block in Java for cleanup code. Understand when it executes and why it is important.">
            <meta name="keywords"
                content="java finally block, try catch finally, cleanup code java, exception handling context, java resource management">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Java Finally Block - Java Tutorial | 8gwifi.org">
            <meta property="og:description"
                content="Ensure your cleanup code runs every time with the Java Finally block.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/java/exceptions-finally.jsp">
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
    "name": "Java Finally Block",
    "description": "Guide to using finally block in Java.",
    "learningResourceType": "tutorial",
    "educationalLevel": "Intermediate",
    "teaches": ["Finally Keyword", "Cleanup Code", "Execution Guarantee"],
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

        <body class="tutorial-body no-preview" data-lesson="exceptions-finally">
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
                                    <span>Finally</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Finally Block</h1>
                                    <div class="lesson-meta">
                                        <span>Intermediate</span>
                                        <span>~10 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">The <code>finally</code> block lets you execute code, subsequent to
                                        a <code>try...catch</code> block, regardless of whether an exception is handled
                                        or not.</p>

                                    <!-- Section 1: Syntax -->
                                    <h2>Syntax</h2>
                                    <pre><code class="language-java">try {
  //  Block of code to try
}
catch(Exception e) {
  //  Block of code to handle errors
}
finally {
  //  Code to be executed regardless of the result
}</code></pre>

                                    <!-- Section 2: Why? -->
                                    <h2>Why use it?</h2>
                                    <p>It is mostly used for <strong>"Cleanup Code"</strong>, such as closing files,
                                        closing database connections, or releasing other resources that must be closed
                                        whether the operation succeeded or failed.</p>

                                    <!-- Section 3: Example -->
                                    <h2>Example</h2>
                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="java/FinallyExample.java" />
                                        <jsp:param name="language" value="java" />
                                        <jsp:param name="editorId" value="compiler-finally" />
                                    </jsp:include>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li>The <code>finally</code> block always executes.</li>
                                            <li>It runs after <code>try</code> and <code>catch</code> blocks.</li>
                                            <li>Useful for closing resources (File Streams, DB connections).</li>
                                        </ul>
                                    </div>

                                    <div style="margin-top: 3rem;">
                                        <% String prevLinkUrl=request.getContextPath()
                                            + "/tutorials/java/exceptions-multiple-catch.jsp" ; String
                                            nextLinkUrl=request.getContextPath()
                                            + "/tutorials/java/exceptions-throw.jsp" ; %>
                                            <jsp:include page="../tutorial-nav.jsp">
                                                <jsp:param name="prevLink" value="<%=prevLinkUrl%>" />
                                                <jsp:param name="prevTitle" value="Multiple Catch" />
                                                <jsp:param name="nextLink" value="<%=nextLinkUrl%>" />
                                                <jsp:param name="nextTitle" value="Throw Keyword →" />
                                                <jsp:param name="currentLessonId" value="exceptions-finally" />
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