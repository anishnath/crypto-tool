<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "exceptions-multiple-catch" );
        request.setAttribute("currentModule", "Exception Handling" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Java Multiple Catch Blocks - Java Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Learn how to handle multiple exceptions in Java using multiple catch blocks. Understand the order of exceptions and specific error handling.">
            <meta name="keywords"
                content="java multiple catch, catch multiple exceptions, java exception hierarchy catch, specific exception handling">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Java Multiple Catch Blocks - Java Tutorial | 8gwifi.org">
            <meta property="og:description"
                content="Handle specific errors efficiently with multiple catch blocks in Java.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/java/exceptions-multiple-catch.jsp">
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
    "name": "Java Multiple Catch Blocks",
    "description": "Guide to using multiple catch blocks in Java.",
    "learningResourceType": "tutorial",
    "educationalLevel": "Intermediate",
    "teaches": ["Multiple Exception Handling", "Catch Block Order", "General vs Specific Exceptions"],
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

        <body class="tutorial-body no-preview" data-lesson="exceptions-multiple-catch">
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
                                    <span>Multiple Catch</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Multiple Catch Blocks</h1>
                                    <div class="lesson-meta">
                                        <span>Intermediate</span>
                                        <span>~15 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">Sometimes a block of code can generate more than one type of
                                        exception. Java allowing you to use multiple <code>catch</code> blocks to handle
                                        different errors differently.</p>

                                    <!-- Section 1: Syntax -->
                                    <h2>Syntax</h2>
                                    <pre><code class="language-java">try {
  //  Block of code
}
catch(ArithmeticException e) {
  //  Handle Math errors
}
catch(ArrayIndexOutOfBoundsException e) {
  //  Handle Array errors
}
catch(Exception e) {
  //  Handle everything else
}</code></pre>

                                    <!-- Section 2: Important Rule -->
                                    <h2>The Golden Rule: Order Matters</h2>
                                    <div class="info-box">
                                        <strong>Important:</strong> You must catch the <strong>most specific</strong>
                                        exceptions first and the <strong>most general</strong> (Exception) last.
                                    </div>
                                    <p>If you put <code>catch(Exception e)</code> first, it will catch
                                        <em>everything</em>, and the specific blocks below it will never be reached
                                        (causing a compile error).</p>

                                    <!-- Section 3: Example -->
                                    <h2>Example</h2>
                                    <p>Let's try to perform an operation that could fail in two ways: dividing by zero
                                        OR accessing a bad index.</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="java/MultipleCatchExample.java" />
                                        <jsp:param name="language" value="java" />
                                        <jsp:param name="editorId" value="compiler-multicatch" />
                                    </jsp:include>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li>Use multiple catch blocks to handle different errors specifically.</li>
                                            <li>Order them from specific (child classes) to general (parent classes).
                                            </li>
                                            <li>Only <strong>one</strong> catch block will be executed.</li>
                                        </ul>
                                    </div>

                                    <div style="margin-top: 3rem;">
                                        <% String prevLinkUrl=request.getContextPath()
                                            + "/tutorials/java/exceptions-try-catch.jsp" ; String
                                            nextLinkUrl=request.getContextPath()
                                            + "/tutorials/java/exceptions-finally.jsp" ; %>
                                            <jsp:include page="../tutorial-nav.jsp">
                                                <jsp:param name="prevLink" value="<%=prevLinkUrl%>" />
                                                <jsp:param name="prevTitle" value="Try-Catch" />
                                                <jsp:param name="nextLink" value="<%=nextLinkUrl%>" />
                                                <jsp:param name="nextTitle" value="Finally Block →" />
                                                <jsp:param name="currentLessonId" value="exceptions-multiple-catch" />
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