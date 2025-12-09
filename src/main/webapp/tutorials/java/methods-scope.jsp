<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "methods-scope" );
        request.setAttribute("currentModule", "Methods & Functions" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Java Variable Scope - Java Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Learn about variable scope in Java. Understand method scope, block scope, and the lifetime of variables.">
            <meta name="keywords"
                content="java variable scope, method scope, block scope, local variables, java scoping rules">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Java Variable Scope - Java Tutorial | 8gwifi.org">
            <meta property="og:description"
                content="Master scoping rules in Java to avoid common variable visibility errors.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/java/methods-scope.jsp">
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
    "name": "Java Variable Scope",
    "description": "Guide to variable visibility and scope in Java.",
    "learningResourceType": "tutorial",
    "educationalLevel": "Beginner",
    "teaches": ["Method Scope", "Block Scope", "Loop Variables"],
    "timeRequired": "PT10M",
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

        <body class="tutorial-body no-preview" data-lesson="methods-scope">
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
                                    <span>Variable Scope</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Variable Scope</h1>
                                    <div class="lesson-meta">
                                        <span>Beginner</span>
                                        <span>~10 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">In Java, variables are only accessible inside the region they are
                                        created. This is called <strong>Scope</strong>.</p>

                                    <!-- Section 1: Method Scope -->
                                    <h2>Method Scope</h2>
                                    <p>Variables declared directly inside a method are available anywhere in the method
                                        <em>following</em> the line of declaration.
                                    </p>

                                    <div class="code-box">
                                        <pre><code class="language-java">public class Main {
    public static void main(String[] args) {
        // Code here CANNOT use x
        
        int x = 100;
        
        // Code here CAN use x
        System.out.println(x);
    }
}</code></pre>
                                    </div>

                                    <!-- Section 2: Block Scope -->
                                    <h2>Block Scope</h2>
                                    <p>A block is code between curly braces <code>{}</code>. Variables declared inside
                                        blocks (like <code>if</code> statements or <code>for</code> loops) are
                                        <strong>only</strong> accessible inside that block.
                                    </p>

                                    <img src="<%=request.getContextPath()%>/tutorials/assets/images/java-scope-diagram.svg"
                                        alt="Java Scope Visibility Diagram" class="diagram-image"
                                        style="max-width: 600px; margin: 2rem auto; display: block;">

                                    <div class="mistake-box">
                                        <strong>Common Error:</strong> Trying to access a variable declared inside an
                                        <code>if</code> block from outside of it.
                                    </div>

                                    <pre><code class="language-java">if (condition) {
    int y = 50; // 'y' is created here
    System.out.println(y);
}
// 'y' is destroyed here
// System.out.println(y); // ERROR!</code></pre>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="java/methods-scope.java" />
                                        <jsp:param name="language" value="java" />
                                        <jsp:param name="editorId" value="compiler-scope" />
                                    </jsp:include>

                                    <!-- Section 3: Loop Variables -->
                                    <h2>Loop Scope</h2>
                                    <p>Variables defined in the loop header (like <code>int i</code> in a for-loop) only
                                        identify inside the loop.</p>
                                    <pre><code class="language-java">for (int i = 0; i < 5; i++) {
    // 'i' works here
}
// 'i' DOES NOT exist here</code></pre>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>Scope</strong> determines where variables can be accessed.</li>
                                            <li><strong>Method Scope:</strong> Variables accessible throughout the
                                                method.</li>
                                            <li><strong>Block Scope:</strong> Variables accessible only within the
                                                <code>{}</code> they are defined in.
                                            </li>
                                        </ul>
                                    </div>

                                    <div style="margin-top: 3rem;">
                                        <% 
                                            // Next module is OOP
                                            String prevLinkUrl = request.getContextPath() + "/tutorials/java/methods-recursion.jsp"; 
                                            String nextLinkUrl = request.getContextPath() + "/tutorials/java/oop-classes.jsp"; 
                                        %>
                                            <jsp:include page="../tutorial-nav.jsp">
                                                <jsp:param name="prevLink" value="<%=prevLinkUrl%>" />
                                                <jsp:param name="prevTitle" value="Recursion" />
                                                <jsp:param name="nextLink" value="<%=nextLinkUrl%>" />
                                                <jsp:param name="nextTitle" value="OOP Classes (Next Module) →" />
                                                <jsp:param name="currentLessonId" value="methods-scope" />
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