<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "methods-basics" );
        request.setAttribute("currentModule", "Methods & Functions" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Java Methods Basics - Java Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Learn the basics of Java methods. Understand how to define, call, and use methods to create reusable code blocks.">
            <meta name="keywords"
                content="java methods, java functions, java define method, java call method, reusable code, java void method">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Java Methods Basics - Java Tutorial | 8gwifi.org">
            <meta property="og:description"
                content="Master the art of reusability in Java with Methods. Learn the syntax and structure.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/java/methods-basics.jsp">
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
    "name": "Java Methods Basics",
    "description": "Introduction to defining and calling methods in Java.",
    "learningResourceType": "tutorial",
    "educationalLevel": "Beginner",
    "teaches": ["Method Definition", "Method Call", "Void Return Type", "Main Method"],
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

        <body class="tutorial-body no-preview" data-lesson="methods-basics">
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
                                    <span>Defining Methods</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Defining Methods</h1>
                                    <div class="lesson-meta">
                                        <span>Beginner</span>
                                        <span>~15 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">A <strong>Method</strong> (often called a function in other
                                        languages) is a block of code that runs only when it is called. Methods are used
                                        to perform certain actions, and they are essential for reusing code: define the
                                        code once, and use it many times.</p>

                                    <!-- Section 1: Anatomy of a Method -->
                                    <h2>Anatomy of a Method</h2>
                                    <p>Every method has a signature that defines its name, return type, and parameters.
                                    </p>

                                    <div class="code-box">
                                        <pre><code class="language-java">public static void myMethod() {
    // Code to be executed
}</code></pre>
                                    </div>

                                    <img src="<%=request.getContextPath()%>/tutorials/assets/images/java-methods-structure.svg"
                                        alt="Java Method Structure Diagram" class="diagram-image"
                                        style="max-width: 650px; margin: 2rem auto; display: block;">

                                    <ul>
                                        <li><strong><code>public static</code></strong>: Modifiers. We use
                                            <code>static</code> here so we can call it from the <code>main</code> method
                                            without creating an object.</li>
                                        <li><strong><code>void</code></strong>: The return type. <code>void</code> means
                                            this method does not return any value.</li>
                                        <li><strong><code>myMethod</code></strong>: The name of the method. Standard
                                            Java naming convention is <code>camelCase</code>.</li>
                                        <li><strong><code>()</code></strong>: Parentheses. Parameters go inside here
                                            (more on that later).</li>
                                    </ul>

                                    <!-- Section 2: Calling a Method -->
                                    <h2>Calling a Method</h2>
                                    <p>To use a method, you "call" or "invoke" it by writing the method's name followed
                                        by two parentheses <code>()</code> and a semicolon.</p>

                                    <pre><code class="language-java">public class Main {
    static void myMethod() {
        System.out.println("I just got executed!");
    }

    public static void main(String[] args) {
        myMethod(); // Call the method
        myMethod(); // Call it again!
    }
}</code></pre>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="java/MethodsBasics.java" />
                                        <jsp:param name="language" value="java" />
                                        <jsp:param name="editorId" value="compiler-methods" />
                                    </jsp:include>

                                    <!-- Section 3: Why Use Methods? -->
                                    <h2>Why Use Methods?</h2>
                                    <div class="info-box">
                                        <ul>
                                            <li><strong>Reusability:</strong> Write code once and use it multiple times.
                                            </li>
                                            <li><strong>Organization:</strong> Break complex programs into smaller,
                                                manageable chunks.</li>
                                            <li><strong>Maintenance:</strong> If logic changes, you only need to update
                                                the code in one place.</li>
                                        </ul>
                                    </div>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li>A method is a block of code that executes when called.</li>
                                            <li>Use <code>camelCase</code> for method names (e.g.,
                                                <code>calculateTax</code>).</li>
                                            <li>The <code>static</code> keyword allows the method to belong to the class
                                                rather than an instance.</li>
                                            <li>The <code>void</code> keyword means no value is returned.</li>
                                        </ul>
                                    </div>

                                    <div style="margin-top: 3rem;">
                                        <% String prevLinkUrl=request.getContextPath()
                                            + "/tutorials/java/loops-control.jsp" ; String
                                            nextLinkUrl=request.getContextPath()
                                            + "/tutorials/java/methods-parameters.jsp" ; %>
                                            <jsp:include page="../tutorial-nav.jsp">
                                                <jsp:param name="prevLink" value="<%=prevLinkUrl%>" />
                                                <jsp:param name="prevTitle" value="Loop Control" />
                                                <jsp:param name="nextLink" value="<%=nextLinkUrl%>" />
                                                <jsp:param name="nextTitle" value="Method Parameters →" />
                                                <jsp:param name="currentLessonId" value="methods-basics" />
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