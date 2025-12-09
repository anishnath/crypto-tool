<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "methods-recursion" );
        request.setAttribute("currentModule", "Methods & Functions" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Java Recursion - Java Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Learn about Java Recursion. How methods can call themselves to solve complex problems like factorials and Fibonacci sequences.">
            <meta name="keywords"
                content="java recursion, java recursive method, factorial java, stopping condition, base case, stack overflow">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Java Recursion - Java Tutorial | 8gwifi.org">
            <meta property="og:description"
                content="Understand Recursion in Java: breaking down big problems into smaller self-expressions.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/java/methods-recursion.jsp">
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
    "name": "Java Recursion",
    "description": "Guide to understanding and using recursion in Java.",
    "learningResourceType": "tutorial",
    "educationalLevel": "Intermediate",
    "teaches": ["Recursion Concept", "Base Case", "Stack Overflow"],
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

        <body class="tutorial-body no-preview" data-lesson="methods-recursion">
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
                                    <span>Recursion</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Recursion</h1>
                                    <div class="lesson-meta">
                                        <span>Intermediate</span>
                                        <span>~20 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">Recursion is a technique where a method calls
                                        <strong>itself</strong> to solve a problem. It's often used to break down
                                        complex problems into simpler versions of themselves.</p>

                                    <!-- Section 1: Basic Concept -->
                                    <h2>How It Works</h2>
                                    <p>Every recursive method needs two parts:</p>
                                    <ol>
                                        <li><strong>Base Case:</strong> The condition to stop calling itself (otherwise,
                                            it loops forever and crashes).</li>
                                        <li><strong>Recursive Case:</strong> The part where the method calls itself with
                                            a modified parameter (moving towards the base case).</li>
                                    </ol>

                                    <div class="code-box">
                                        <pre><code class="language-java">int factorial(int n) {
    if (n == 1) {
        return 1; // Base Case: Stop!
    } else {
        return n * factorial(n - 1); // Recursive Step
    }
}</code></pre>
                                    </div>

                                    <img src="<%=request.getContextPath()%>/tutorials/assets/images/java-recursion-stack.svg"
                                        alt="Recursion Stack Trace" class="diagram-image"
                                        style="max-width: 500px; margin: 2rem auto; display: block;">

                                    <!-- Section 2: Example -->
                                    <h2>Example: Mathematical Factorial</h2>
                                    <p>The factorial of 5 (written as 5!) is <code>5 * 4 * 3 * 2 * 1</code>.</p>
                                    <ul>
                                        <li><code>factorial(5)</code> returns <code>5 * factorial(4)</code></li>
                                        <li><code>factorial(4)</code> returns <code>4 * factorial(3)</code></li>
                                        <li>...and so on, until <code>factorial(1)</code> returns 1.</li>
                                    </ul>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="java/RecursionExample.java" />
                                        <jsp:param name="language" value="java" />
                                        <jsp:param name="editorId" value="compiler-recursion" />
                                    </jsp:include>

                                    <!-- Section 3: The Danger -->
                                    <h2>Stack Overflow Error</h2>
                                    <p>If you forget the Base Case, the method keeps calling itself infinitely until the
                                        computer runs out of memory. In Java, this throws a
                                        <code>StackOverflowError</code>.</p>

                                    <div class="mistake-box">
                                        <pre><code class="language-java">// BAD CODE (Crashes)
int badMethod(int n) {
    return n * badMethod(n - 1); // No stopping condition!
}</code></pre>
                                    </div>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li>Recursion is when a function calls itself.</li>
                                            <li>Always define a <strong>Base Case</strong> to stop the recursion.</li>
                                            <li>Useful for traversing trees, directories, or solving mathematical
                                                series.</li>
                                        </ul>
                                    </div>

                                    <div style="margin-top: 3rem;">
                                        <% String prevLinkUrl=request.getContextPath()
                                            + "/tutorials/java/methods-return.jsp" ; String
                                            nextLinkUrl=request.getContextPath() + "/tutorials/java/methods-scope.jsp" ;
                                            %>
                                            <jsp:include page="../tutorial-nav.jsp">
                                                <jsp:param name="prevLink" value="<%=prevLinkUrl%>" />
                                                <jsp:param name="prevTitle" value="Return Values" />
                                                <jsp:param name="nextLink" value="<%=nextLinkUrl%>" />
                                                <jsp:param name="nextTitle" value="Method Scope →" />
                                                <jsp:param name="currentLessonId" value="methods-recursion" />
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