<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "methods-overloading" );
        request.setAttribute("currentModule", "Methods & Functions" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Java Method Overloading - Java Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Learn about Method Overloading in Java. How to define multiple methods with the same name but different parameters.">
            <meta name="keywords"
                content="java method overloading, unique method signature, java function overloading, methods same name, java polymorphism">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Java Method Overloading - Java Tutorial | 8gwifi.org">
            <meta property="og:description"
                content="Increase code readability with Method Overloading. Use the same method name for different data types.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/java/methods-overloading.jsp">
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
    "name": "Java Method Overloading",
    "description": "Guide to Java method overloading concepts and best practices.",
    "learningResourceType": "tutorial",
    "educationalLevel": "Beginner",
    "teaches": ["Method Overloading", "Method Signature", "Polymorphism Basics"],
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

        <body class="tutorial-body no-preview" data-lesson="methods-overloading">
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
                                    <span>Method Overloading</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Method Overloading</h1>
                                    <div class="lesson-meta">
                                        <span>Beginner</span>
                                        <span>~15 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">Method Overloading allows multiple methods to have the <strong>same
                                            name</strong> with <strong>different parameters</strong>.</p>

                                    <!-- Section 1: Concept -->
                                    <h2>The Concept</h2>
                                    <p>Imagine you want to create a method that adds numbers. Instead of defining
                                        <code>addIntegers()</code> and <code>addDoubles()</code>, you can simply define
                                        <code>add()</code> for both.</p>

                                    <div class="code-box">
                                        <pre><code class="language-java">int add(int x, int y) { ... }
double add(double x, double y) { ... }</code></pre>
                                    </div>

                                    <!-- Section 2: How it Works -->
                                    <h2>How Java Distinguishes Them</h2>
                                    <p>Java differentiates overloaded methods based on the <strong>number</strong> and
                                        <strong>type</strong> of parameters. The return type alone is NOT enough to
                                        overload a method.</p>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Method Signature</th>
                                                <th>Valid Overload?</th>
                                                <th>Reason</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><code>void print(String s)</code></td>
                                                <td>Original</td>
                                                <td>-</td>
                                            </tr>
                                            <tr>
                                                <td><code>void print(int i)</code></td>
                                                <td>Yes</td>
                                                <td>Different parameter type (int vs String)</td>
                                            </tr>
                                            <tr>
                                                <td><code>void print(String s, int i)</code></td>
                                                <td>Yes</td>
                                                <td>Different number of parameters (2 vs 1)</td>
                                            </tr>
                                            <tr>
                                                <td><code>int print(String s)</code></td>
                                                <td><strong>No</strong></td>
                                                <td>Only return type changed</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="java/MethodOverloading.java" />
                                        <jsp:param name="language" value="java" />
                                        <jsp:param name="editorId" value="compiler-overloading" />
                                    </jsp:include>

                                    <!-- Section 3: Benefits -->
                                    <h2>Benefits of Overloading</h2>
                                    <ul>
                                        <li><strong>Readability:</strong> Users of your method don't have to remember
                                            different names for the same action (e.g., <code>System.out.println</code>
                                            works for text, numbers, and booleans!).</li>
                                        <li><strong>Clean Code:</strong> Reduces name clutter in your class.</li>
                                    </ul>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li>Overloading happens when methods have the same name but different
                                                parameter lists.</li>
                                            <li>The parameter list must differ in the number of parameters or the data
                                                types of parameters.</li>
                                            <li>Changing only the return type does not constitute overloading.</li>
                                        </ul>
                                    </div>

                                    <div style="margin-top: 3rem;">
                                        <% String prevLinkUrl=request.getContextPath()
                                            + "/tutorials/java/methods-parameters.jsp" ; String
                                            nextLinkUrl=request.getContextPath() + "/tutorials/java/methods-return.jsp"
                                            ; %>
                                            <jsp:include page="../tutorial-nav.jsp">
                                                <jsp:param name="prevLink" value="<%=prevLinkUrl%>" />
                                                <jsp:param name="prevTitle" value="Method Parameters" />
                                                <jsp:param name="nextLink" value="<%=nextLinkUrl%>" />
                                                <jsp:param name="nextTitle" value="Return Values →" />
                                                <jsp:param name="currentLessonId" value="methods-overloading" />
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