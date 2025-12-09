<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "exceptions-basics" );
        request.setAttribute("currentModule", "Exception Handling" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Java Exceptions Basics - Java Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Learn the basics of Java Exceptions. Understand the hierarchy, checked vs unchecked exceptions, and the difference between Error and Exception.">
            <meta name="keywords"
                content="java exceptions, java error vs exception, checked vs unchecked exception, throwable hierarchy, java exception handling">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Java Exceptions Basics - Java Tutorial | 8gwifi.org">
            <meta property="og:description" content="Master the fundamentals of Java Exception handling and hierarchy.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/java/exceptions-basics.jsp">
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
    "name": "Java Exception Basics",
    "description": "Introduction to Java Exception hierarchy.",
    "learningResourceType": "tutorial",
    "educationalLevel": "Intermediate",
    "teaches": ["Exception Hierarchy", "Checked vs Unchecked", "Error vs Exception"],
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

        <body class="tutorial-body no-preview" data-lesson="exceptions-basics">
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
                                    <span>Exception Basics</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Java Exceptions</h1>
                                    <div class="lesson-meta">
                                        <span>Intermediate</span>
                                        <span>~15 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">An <strong>Exception</strong> is an event (problem) that occurs
                                        during the execution of a program that disrupts the normal flow of instructions.
                                        Java provides a powerful mechanism to handle these runtime errors so that the
                                        normal flow of the application can be maintained.</p>

                                    <!-- Section 1: Hierarchy -->
                                    <h2>The Hierarchy</h2>
                                    <p>All exception types are subclasses of the class <code>Throwable</code>.</p>

                                    <img src="<%=request.getContextPath()%>/tutorials/assets/images/java-exceptions-hierarchy.svg"
                                        alt="Java Exception Hierarchy Diagram" class="diagram-image"
                                        style="max-width: 600px; margin: 2rem auto; display: block;">

                                    <ul class="feature-list">
                                        <li><strong>Error:</strong> Serious problems that a reasonable application
                                            should not try to catch (e.g., <code>OutOfMemoryError</code>).</li>
                                        <li><strong>Exception:</strong> Conditions that a reasonable application might
                                            want to catch.</li>
                                    </ul>

                                    <!-- Section 2: Types -->
                                    <h2>Types of Exceptions</h2>
                                    <p>There are mainly two types of exceptions:</p>

                                    <h3>1. Checked Exceptions</h3>
                                    <p>Exceptions that are checked at <strong>compile-time</strong>. If some code within
                                        a method throws a checked exception, then the method must either handle the
                                        exception or it must specify the exception using <code>throws</code> keyword.
                                    </p>
                                    <ul>
                                        <li>Examples: <code>IOException</code>, <code>SQLException</code>.</li>
                                    </ul>

                                    <h3>2. Unchecked Exceptions (Runtime Exceptions)</h3>
                                    <p>Exceptions that are not checked at compile-time. They usually occur due to
                                        programming errors.</p>
                                    <ul>
                                        <li>Examples: <code>NullPointerException</code>,
                                            <code>ArrayIndexOutOfBoundsException</code>,
                                            <code>ArithmeticException</code>.</li>
                                    </ul>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="info-box">
                                        Remember: <strong>Errors</strong> are usually fatal (system crashes).
                                        <strong>Exceptions</strong> are manageable issues that your code can recover
                                        from.
                                    </div>

                                    <div style="margin-top: 3rem;">
                                        <% String prevLinkUrl=request.getContextPath()
                                            + "/tutorials/java/collections-generics.jsp" ; String
                                            nextLinkUrl=request.getContextPath()
                                            + "/tutorials/java/exceptions-try-catch.jsp" ; %>
                                            <jsp:include page="../tutorial-nav.jsp">
                                                <jsp:param name="prevLink" value="<%=prevLinkUrl%>" />
                                                <jsp:param name="prevTitle" value="Generics" />
                                                <jsp:param name="nextLink" value="<%=nextLinkUrl%>" />
                                                <jsp:param name="nextTitle" value="Try-Catch →" />
                                                <jsp:param name="currentLessonId" value="exceptions-basics" />
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