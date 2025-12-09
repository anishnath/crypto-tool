<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "exceptions-try-catch" );
        request.setAttribute("currentModule", "Exception Handling" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Java Try-Catch - Java Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Learn how to handle exceptions in Java using the try and catch keywords. Prevent program crashes and handle errors gracefully.">
            <meta name="keywords"
                content="java try catch, handle exception, java exception handling example, try block, catch block">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Java Try-Catch - Java Tutorial | 8gwifi.org">
            <meta property="og:description" content="Step-by-step guide to using try-catch blocks in Java.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/java/exceptions-try-catch.jsp">
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
    "name": "Java Try-Catch",
    "description": "Guide to using try-catch blocks in Java.",
    "learningResourceType": "tutorial",
    "educationalLevel": "Intermediate",
    "teaches": ["Try Block", "Catch Block", "Handling ArithmeticException"],
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

        <body class="tutorial-body no-preview" data-lesson="exceptions-try-catch">
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
                                    <span>Try-Catch</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Java Try-Catch</h1>
                                    <div class="lesson-meta">
                                        <span>Intermediate</span>
                                        <span>~15 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">The <code>try</code> statement allows you to define a block of code
                                        to be tested for errors while it is being executed.<br>The <code>catch</code>
                                        statement allows you to define the action to be taken if an error occurs in the
                                        try block.</p>

                                    <!-- Section 1: Syntax -->
                                    <h2>Syntax</h2>
                                    <pre><code class="language-java">try {
  //  Block of code to try
}
catch(Exception e) {
  //  Block of code to handle errors
}</code></pre>

                                    <!-- Section 2: Example -->
                                    <h2>Example</h2>
                                    <p>If an error occurs, we can use <code>try...catch</code> to "catch" the error and
                                        execute some code to handle it instead of letting the program crash.</p>

                                    <div class="code-box">
                                        <pre><code class="language-java">try {
  int[] myNumbers = {1, 2, 3};
  System.out.println(myNumbers[10]); // Error!
} catch (Exception e) {
  System.out.println("Something went wrong.");
}</code></pre>
                                    </div>

                                    <p>Without the try-catch block, the program would stop immediately and show a scary
                                        error message to the user.</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="java/TryCatchExample.java" />
                                        <jsp:param name="language" value="java" />
                                        <jsp:param name="editorId" value="compiler-trycatch" />
                                    </jsp:include>

                                    <!-- Section 3: Printing the Stack Trace -->
                                    <h2>Debugging</h2>
                                    <p>Inside the catch block, you usually want to print details about the error so you
                                        can fix it. You can print the exception object <code>e</code> or call
                                        <code>e.printStackTrace()</code>.</p>
                                    <pre><code class="language-java">catch (Exception e) {
  System.out.println("Error: " + e.getMessage());
  e.printStackTrace();
}</code></pre>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li>Put code that <i>might</i> throw an error inside
                                                <code>try { ... }</code>.</li>
                                            <li>Put code to handle the error inside
                                                <code>catch(Exception e) { ... }</code>.</li>
                                            <li>This prevents your application from crashing unexpectedly.</li>
                                        </ul>
                                    </div>

                                    <div style="margin-top: 3rem;">
                                        <% String prevLinkUrl=request.getContextPath()
                                            + "/tutorials/java/exceptions-basics.jsp" ; String
                                            nextLinkUrl=request.getContextPath()
                                            + "/tutorials/java/exceptions-multiple-catch.jsp" ; %>
                                            <jsp:include page="../tutorial-nav.jsp">
                                                <jsp:param name="prevLink" value="<%=prevLinkUrl%>" />
                                                <jsp:param name="prevTitle" value="Exception Basics" />
                                                <jsp:param name="nextLink" value="<%=nextLinkUrl%>" />
                                                <jsp:param name="nextTitle" value="Multiple Catch Blocks →" />
                                                <jsp:param name="currentLessonId" value="exceptions-try-catch" />
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