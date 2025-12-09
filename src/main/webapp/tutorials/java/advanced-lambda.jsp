<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "advanced-lambda" );
        request.setAttribute("currentModule", "Advanced Topics" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Java Lambda Expressions - Java Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Learn Java Lambda Expressions. Understand functional programming concepts, arrow syntax, and Functional Interfaces in Java 8+.">
            <meta name="keywords"
                content="java lambda expressions, java 8 features, functional interface, arrow syntax java, anonymous functions java">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Java Lambda Expressions - Java Tutorial | 8gwifi.org">
            <meta property="og:description" content="Master the concise syntax of Lambda Expressions in Java.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/java/advanced-lambda.jsp">
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
    "name": "Java Lambda Expressions",
    "description": "Introduction to Lambda Expressions in Java.",
    "learningResourceType": "tutorial",
    "educationalLevel": "Advanced",
    "teaches": ["Lambda Syntax", "Functional Interfaces", "Concise Code"],
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

        <body class="tutorial-body no-preview" data-lesson="advanced-lambda">
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
                                    <span>Lambda Expressions</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Lambda Expressions</h1>
                                    <div class="lesson-meta">
                                        <span>Advanced</span>
                                        <span>~20 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">Lambda expressions were added in Java 8. They provide a clear and
                                        concise way to represent one method interface using an expression. They enable
                                        <strong>Functional Programming</strong> in Java.
                                    </p>

                                    <!-- Section 1: Syntax -->
                                    <h2>Syntax</h2>
                                    <p>The simplest lambda expression contains a single parameter and an expression:</p>
                                    <pre><code class="language-java">parameter -> expression</code></pre>

                                    <p>For more parameters or complex logic:</p>
                                    <pre><code class="language-java">(param1, param2) -> { 
    // code block 
    return something; 
}</code></pre>

                                    <!-- Section 2: Functional Interface -->
                                    <h2>Functional Interface</h2>
                                    <p>A Lambda expression can be used wherever the type is a <strong>Functional
                                            Interface</strong>. A functional interface is an interface with only one
                                        abstract method.</p>
                                    <p>Common examples: <code>Runnable</code>, <code>Comparator</code>,
                                        <code>ActionListener</code>.
                                    </p>

                                    <!-- Section 3: Before vs After -->
                                    <h3>Before Java 8 (Anonymous Class)</h3>
                                    <pre><code class="language-java">Runnable r = new Runnable() {
    public void run() {
        System.out.println("Running...");
    }
};</code></pre>

                                    <h3>After Java 8 (Lambda)</h3>
                                    <pre><code class="language-java">Runnable r = () -> System.out.println("Running...");</code></pre>

                                    <!-- Section 4: Example -->
                                    <h2>Full Example</h2>
                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="java/LambdaExample.java" />
                                        <jsp:param name="language" value="java" />
                                        <jsp:param name="editorId" value="compiler-lambda" />
                                    </jsp:include>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li>Lambdas make code more concise and readable.</li>
                                            <li>They remove the boilerplate of Anonymous Inner Classes.</li>
                                            <li>Syntax: <code>(parameters) -> { body }</code>.</li>
                                        </ul>
                                    </div>

                                    <div style="margin-top: 3rem;">
                                        <% 
                                            // Linking to the end of Module 10
                                            String prevLinkUrl = request.getContextPath() + "/tutorials/java/io-nio.jsp"; 
                                            String nextLinkUrl = request.getContextPath() + "/tutorials/java/advanced-streams.jsp"; 
                                        %>
                                            <jsp:include page="../tutorial-nav.jsp">
                                                <jsp:param name="prevLink" value="<%=prevLinkUrl%>" />
                                                <jsp:param name="prevTitle" value="Module 10: NIO" />
                                                <jsp:param name="nextLink" value="<%=nextLinkUrl%>" />
                                                <jsp:param name="nextTitle" value="Streams API →" />
                                                <jsp:param name="currentLessonId" value="advanced-lambda" />
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