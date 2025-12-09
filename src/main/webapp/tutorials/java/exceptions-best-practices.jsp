<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "exceptions-best-practices" );
        request.setAttribute("currentModule", "Exception Handling" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Java Exception Handling Best Practices - Java Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Learn the best practices for handling exceptions in Java. Write cleaner, more robust, and maintainable code.">
            <meta name="keywords"
                content="java exception best practices, java error handling tips, catch block best practices, logging exceptions">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Java Exception Best Practices - Java Tutorial | 8gwifi.org">
            <meta property="og:description"
                content="Write professional-grade error handling code with these Java best practices.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/java/exceptions-best-practices.jsp">
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
    "name": "Java Exception Best Practices",
    "description": "Guide to professional exception handling patterns.",
    "learningResourceType": "tutorial",
    "educationalLevel": "Intermediate",
    "teaches": ["Logging", "Cleaning up resources", "Catching specific exceptions"],
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

        <body class="tutorial-body no-preview" data-lesson="exceptions-best-practices">
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
                                    <span>Best Practices</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Exception Handling Best Practices</h1>
                                    <div class="lesson-meta">
                                        <span>Intermediate</span>
                                        <span>~15 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">Writing `try-catch` blocks is easy, but writing <em>good</em> error
                                        handling code requires discipline. Here are the top rules to follow.</p>

                                    <!-- Rule 1 -->
                                    <h2>1. Never Swallow Exceptions</h2>
                                    <p>Don't catch an exception and do empty logic. This hides the error forever.</p>
                                    <pre><code class="language-java">// BAD
catch (Exception e) { } 

// GOOD
catch (Exception e) {
    e.printStackTrace(); // or Logger.error()
}</code></pre>

                                    <!-- Rule 2 -->
                                    <h2>2. Catch Specific Exceptions</h2>
                                    <p>Always catch the most specific exception first. Don't just catch
                                        <code>Exception</code> for everything.
                                    </p>

                                    <!-- Rule 3 -->
                                    <h2>3. Clean Up Resources</h2>
                                    <p>Always use a <code>finally</code> block or "Try-with-Resources" to close files
                                        and connections.</p>

                                    <div class="code-box">
                                        <pre><code class="language-java">// Try-with-Resources (Java 7+)
// Automatically closes the resource
try (Scanner scanner = new Scanner(new File("test.txt"))) {
    while (scanner.hasNext()) {
        System.out.println(scanner.nextLine());
    }
} catch (FileNotFoundException e) {
    e.printStackTrace();
}</code></pre>
                                    </div>

                                    <!-- Rule 4 -->
                                    <h2>4. Don't Catch 'Throwable'</h2>
                                    <p>Never catch <code>Throwable</code> because it includes <code>Error</code> (like
                                        OutOfMemoryError) which you shouldn't try to handle.</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="java/BestPracticesExample.java" />
                                        <jsp:param name="language" value="java" />
                                        <jsp:param name="editorId" value="compiler-practices" />
                                    </jsp:include>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li>Log the exception or handle it; never ignore it.</li>
                                            <li>Use <strong>Try-with-Resources</strong> for auto-closing.</li>
                                            <li>Be specific in your catch blocks.</li>
                                        </ul>
                                    </div>

                                    <div style="margin-top: 3rem;">
                                        <% 
                                            // Linking to Module 10
                                            String prevLinkUrl = request.getContextPath() + "/tutorials/java/exceptions-custom.jsp"; 
                                            String nextLinkUrl = request.getContextPath() + "/tutorials/java/io-file.jsp"; 
                                        %>
                                            <jsp:include page="../tutorial-nav.jsp">
                                                <jsp:param name="prevLink" value="<%=prevLinkUrl%>" />
                                                <jsp:param name="prevTitle" value="Custom Exceptions" />
                                                <jsp:param name="nextLink" value="<%=nextLinkUrl%>" />
                                                <jsp:param name="nextTitle" value="Module 10: File I/O →" />
                                                <jsp:param name="currentLessonId" value="exceptions-best-practices" />
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