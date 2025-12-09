<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "methods-return" );
        request.setAttribute("currentModule", "Methods & Functions" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Java Method Return Values - Java Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Learn how to return values from Java methods. Understand the return keyword and different return types.">
            <meta name="keywords"
                content="java method return value, java return keyword, java functions return, java int return, java boolean return">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Java Method Return Values - Java Tutorial | 8gwifi.org">
            <meta property="og:description"
                content="Unlock the power of calculating and returning data with Java methods.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/java/methods-return.jsp">
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
    "name": "Java Method Return Values",
    "description": "Guide to returning values from Java methods.",
    "learningResourceType": "tutorial",
    "educationalLevel": "Beginner",
    "teaches": ["Return Keyword", "Return Types", "Returning Booleans"],
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

        <body class="tutorial-body no-preview" data-lesson="methods-return">
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
                                    <span>Return Values</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Return Values</h1>
                                    <div class="lesson-meta">
                                        <span>Beginner</span>
                                        <span>~15 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">So far, we've used <code>void</code> methods that perform an action
                                        but don't give anything back. If you want a method to calculate something and
                                        <strong>return</strong> the result, you use a return value.</p>

                                    <!-- Section 1: The return Keyword -->
                                    <h2>The <code>return</code> Keyword</h2>
                                    <p>Instead of <code>void</code>, you replace it with the data type of the value you
                                        want to return (e.g., <code>int</code>, <code>String</code>,
                                        <code>double</code>).</p>
                                    <p>Inside the method, use the <code>return</code> keyword to send the value back.
                                    </p>

                                    <div class="code-box">
                                        <pre><code class="language-java">static int calculateSum(int x, int y) {
    return x + y; // Returns an integer
}

public static void main(String[] args) {
    int result = calculateSum(5, 3);
    System.out.println(result); // Outputs 8
}</code></pre>
                                    </div>

                                    <div class="warning-box">
                                        <strong>Rule:</strong> If you declare a return type (e.g., <code>int</code>),
                                        your method MUST return a value of that type in all possible execution paths.
                                    </div>

                                    <!-- Section 2: Storing the Result -->
                                    <h2>Using the Return Value</h2>
                                    <p>When a method returns a value, you can:</p>
                                    <ul>
                                        <li>Store it in a variable: <code>int x = myMethod();</code></li>
                                        <li>Use it directly in an expression: <code>if (myMethod() > 10) ...</code></li>
                                        <li>Print it directly: <code>System.out.println(myMethod());</code></li>
                                    </ul>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="java/MethodReturn.java" />
                                        <jsp:param name="language" value="java" />
                                        <jsp:param name="editorId" value="compiler-return" />
                                    </jsp:include>

                                    <!-- Section 3: Returning Booleans -->
                                    <h2>Returning Booleans (for Checks)</h2>
                                    <p>This is very common for validation methods.</p>
                                    <pre><code class="language-java">static boolean isEven(int number) {
    if (number % 2 == 0) {
        return true;
    } else {
        return false;
    }
}</code></pre>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li>Replace <code>void</code> with a data type (e.g., <code>int</code>) to
                                                define a return value.</li>
                                            <li>Use the <code>return</code> keyword to exit the method and pass data
                                                back.</li>
                                            <li>A method stops executing immediately when it reaches a
                                                <code>return</code> statement.</li>
                                        </ul>
                                    </div>

                                    <div style="margin-top: 3rem;">
                                        <% String prevLinkUrl=request.getContextPath()
                                            + "/tutorials/java/methods-overloading.jsp" ; String
                                            nextLinkUrl=request.getContextPath()
                                            + "/tutorials/java/methods-recursion.jsp" ; %>
                                            <jsp:include page="../tutorial-nav.jsp">
                                                <jsp:param name="prevLink" value="<%=prevLinkUrl%>" />
                                                <jsp:param name="prevTitle" value="Method Overloading" />
                                                <jsp:param name="nextLink" value="<%=nextLinkUrl%>" />
                                                <jsp:param name="nextTitle" value="Recursion →" />
                                                <jsp:param name="currentLessonId" value="methods-return" />
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