<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "exceptions-throw" );
        request.setAttribute("currentModule", "Exception Handling" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Java Throw and Throws - Java Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Learn the difference between throw and throws in Java. Understand how to explicitly throw exceptions and declare them in method signatures.">
            <meta name="keywords"
                content="java throw vs throws, throw keyword, throws keyword, java exception propagation, custom exception throwing">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Java Throw and Throws - Java Tutorial | 8gwifi.org">
            <meta property="og:description" content="Master the art of creating and propagating exceptions in Java.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/java/exceptions-throw.jsp">
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
    "name": "Java Throw and Throws",
    "description": "Guide to using throw and throws keywords in Java.",
    "learningResourceType": "tutorial",
    "educationalLevel": "Intermediate",
    "teaches": ["throw keyword", "throws keyword", "Creating Exceptions"],
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

        <body class="tutorial-body no-preview" data-lesson="exceptions-throw">
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
                                    <span>Throw & Throws</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Throw and Throws</h1>
                                    <div class="lesson-meta">
                                        <span>Intermediate</span>
                                        <span>~20 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">Java provides the <code>throw</code> keyword to explicitly throw an
                                        exception, and the <code>throws</code> keyword to declare an exception.</p>

                                    <!-- Section 1: The 'throw' keyword -->
                                    <h2>The 'throw' Keyword</h2>
                                    <p>The <code>throw</code> statement allows you to create a custom error. You can
                                        throw mostly any exception type (arithmetic, array issue, or custom logic).</p>
                                    <pre><code class="language-java">if (age < 18) {
  throw new ArithmeticException("Access denied - You must be at least 18 years old.");
}</code></pre>

                                    <!-- Section 2: The 'throws' keyword -->
                                    <h2>The 'throws' Keyword</h2>
                                    <p>The <code>throws</code> keyword is used in the method signature to declare that
                                        this method <em>might</em> throw one of the listed exceptions. The caller of
                                        this method must handling these exceptions (using try-catch).</p>
                                    <pre><code class="language-java">public void checkFile() throws IOException {
  // Code that might cause an input/output error
}</code></pre>

                                    <!-- Section 3: Checked vs Unchecked -->
                                    <div class="info-box">
                                        <strong>Rule:</strong> Checked exceptions (like IOException) MUST be declared
                                        with <code>throws</code> or handled with <code>try-catch</code>. Unchecked
                                        exceptions (like ArithmeticException) don't require this, but it's good practice
                                        to document them.
                                    </div>

                                    <!-- Section 4: Example -->
                                    <h2>Full Example</h2>
                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="java/ThrowExample.java" />
                                        <jsp:param name="language" value="java" />
                                        <jsp:param name="editorId" value="compiler-throw" />
                                    </jsp:include>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li>Use <strong>throw</strong> implies "Do it now!" (Create an exception).
                                            </li>
                                            <li>Use <strong>throws</strong> implies "Watch out!" (Declare it in method
                                                header).</li>
                                            <li>This mechanism allows errors to bubble up to where they can be handled
                                                properly.</li>
                                        </ul>
                                    </div>

                                    <div style="margin-top: 3rem;">
                                        <% String prevLinkUrl=request.getContextPath()
                                            + "/tutorials/java/exceptions-finally.jsp" ; String
                                            nextLinkUrl=request.getContextPath()
                                            + "/tutorials/java/exceptions-custom.jsp" ; %>
                                            <jsp:include page="../tutorial-nav.jsp">
                                                <jsp:param name="prevLink" value="<%=prevLinkUrl%>" />
                                                <jsp:param name="prevTitle" value="Finally Block" />
                                                <jsp:param name="nextLink" value="<%=nextLinkUrl%>" />
                                                <jsp:param name="nextTitle" value="Custom Exceptions →" />
                                                <jsp:param name="currentLessonId" value="exceptions-throw" />
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