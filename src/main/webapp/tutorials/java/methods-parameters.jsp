<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "methods-parameters" );
        request.setAttribute("currentModule", "Methods & Functions" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Java Method Parameters - Java Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Learn how to pass data to Java methods using parameters and arguments. Master multiple parameters and type consistency.">
            <meta name="keywords"
                content="java method parameters, java arguments, passing data to methods, java method signature, java multiple parameters">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Java Method Parameters - Java Tutorial | 8gwifi.org">
            <meta property="og:description"
                content="Make your methods dynamic by passing information through parameters.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/java/methods-parameters.jsp">
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
    "name": "Java Method Parameters",
    "description": "Guide to using parameters in Java methods.",
    "learningResourceType": "tutorial",
    "educationalLevel": "Beginner",
    "teaches": ["Parameters vs Arguments", "Multiple Parameters", "Type Matching"],
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

        <body class="tutorial-body no-preview" data-lesson="methods-parameters">
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
                                    <span>Method Parameters</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Method Parameters</h1>
                                    <div class="lesson-meta">
                                        <span>Beginner</span>
                                        <span>~15 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">Information can be passed to methods as <strong>parameters</strong>.
                                        Parameters act as variables inside the method.</p>

                                    <!-- Section 1: Parameters vs Arguments -->
                                    <h2>Parameters vs. Arguments</h2>
                                    <p>These terms are often used interchangeably, but there is a slight difference:</p>
                                    <ul>
                                        <li><strong>Parameter:</strong> The variable defined in the method declaration
                                            (e.g., <code>String fname</code>).</li>
                                        <li><strong>Argument:</strong> The actual value you pass when you call the
                                            method (e.g., <code>"Liam"</code>).</li>
                                    </ul>

                                    <div class="code-box">
                                        <pre><code class="language-java">// 'fname' is a parameter
static void printName(String fname) {
    System.out.println("Hello " + fname);
}

public static void main(String[] args) {
    // "Liam" is an argument
    printName("Liam");
}</code></pre>
                                    </div>

                                    <!-- Section 2: Multiple Parameters -->
                                    <h2>Multiple Parameters</h2>
                                    <p>You can have as many parameters as you like, separated by commas.</p>
                                    <pre><code class="language-java">static void printDetails(String name, int age) {
    System.out.println(name + " is " + age + " years old.");
}</code></pre>

                                    <div class="warning-box">
                                        <strong>Order Matters!</strong> When you call the method, arguments must be
                                        passed in the same order as parameters. Passing an <code>int</code> where a
                                        <code>String</code> is expected will cause an error.
                                    </div>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="java/MethodParameters.java" />
                                        <jsp:param name="language" value="java" />
                                        <jsp:param name="editorId" value="compiler-params" />
                                    </jsp:include>

                                    <!-- Section 3: Values, Not References (Basic Types) -->
                                    <h2>Values vs Variables</h2>
                                    <p>You can pass literal values (like <code>5</code>) or variables (like
                                        <code>x</code>) as arguments.</p>
                                    <pre><code class="language-java">int x = 10;
myMethod(x); // Passing variable
myMethod(20); // Passing literal</code></pre>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li>Parameters allow you to input data into methods.</li>
                                            <li>Arguments are the actual values sent to the method.</li>
                                            <li>Multiple parameters are comma-separated.</li>
                                            <li>The order and type of arguments must match the parameters.</li>
                                        </ul>
                                    </div>

                                    <div style="margin-top: 3rem;">
                                        <% String prevLinkUrl=request.getContextPath()
                                            + "/tutorials/java/methods-basics.jsp" ; String
                                            nextLinkUrl=request.getContextPath()
                                            + "/tutorials/java/methods-overloading.jsp" ; %>
                                            <jsp:include page="../tutorial-nav.jsp">
                                                <jsp:param name="prevLink" value="<%=prevLinkUrl%>" />
                                                <jsp:param name="prevTitle" value="Defining Methods" />
                                                <jsp:param name="nextLink" value="<%=nextLinkUrl%>" />
                                                <jsp:param name="nextTitle" value="Method Overloading →" />
                                                <jsp:param name="currentLessonId" value="methods-parameters" />
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