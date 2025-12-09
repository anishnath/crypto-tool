<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "operators-ternary" );
        request.setAttribute("currentModule", "Operators & Expressions" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Java Ternary Operator (? :) - Java Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Learn how to use the Java Ternary Operator (conditional operator) to write concise if-else statements. Simple examples and best practices.">
            <meta name="keywords"
                content="java ternary operator, java conditional operator, java question mark operator, java if else shorthand">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Java Ternary Operator - Java Tutorial | 8gwifi.org">
            <meta property="og:description"
                content="Master the Java Ternary Operator for cleaner, shorter conditional code.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/java/operators-ternary.jsp">
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
    "name": "Java Ternary Operator",
    "description": "Guide to using the ternary operator (conditional operator) in Java.",
    "learningResourceType": "tutorial",
    "educationalLevel": "Beginner",
    "teaches": ["Ternary Operator", "Conditional Logic", "Code Conciseness"],
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

        <body class="tutorial-body no-preview" data-lesson="operators-ternary">
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
                                    <span>Ternary Operator</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Ternary Operator</h1>
                                    <div class="lesson-meta">
                                        <span>Beginner</span>
                                        <span>~10 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">The ternary operator (also known as the conditional operator) is a
                                        shorthand way to write simple <code>if-else</code> statements. It's the only
                                        operator in Java that takes three operands.</p>

                                    <!-- Section 1: Syntax -->
                                    <h2>Syntax</h2>
                                    <div class="code-box">
                                        <pre><code class="language-java">variable = (condition) ? expressionTrue : expressionFalse;</code></pre>
                                    </div>

                                    <p>It works like this:</p>
                                    <ol>
                                        <li>Evaluate the <code>condition</code>.</li>
                                        <li>If true, execute/return <code>expressionTrue</code>.</li>
                                        <li>If false, execute/return <code>expressionFalse</code>.</li>
                                    </ol>

                                    <!-- Section 2: Examples -->
                                    <h2>Example: Replacing If-Else</h2>
                                    <p>Let's find the maximum of two numbers.</p>

                                    <div class="side-by-side">
                                        <div class="mistake-box">
                                            <h4>Using If-Else</h4>
                                            <pre><code class="language-java">int max;
if (a > b) {
    max = a;
} else {
    max = b;
}</code></pre>
                                        </div>

                                        <div class="tip-box">
                                            <h4>Using Ternary Operator</h4>
                                            <pre><code class="language-java">int max = (a > b) ? a : b;</code></pre>
                                        </div>
                                    </div>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="java/TernaryOperator.java" />
                                        <jsp:param name="language" value="java" />
                                        <jsp:param name="editorId" value="compiler-ternary" />
                                    </jsp:include>

                                    <!-- Section 3: Nested Ternary -->
                                    <h2>Nested Ternary Operators</h2>
                                    <p>You can nest ternary operators, but be careful! It can make code hard to read.
                                    </p>

                                    <pre><code class="language-java">// Check if number is positive, negative, or zero
String result = (num > 0) ? "Positive" : ((num < 0) ? "Negative" : "Zero");</code></pre>

                                    <div class="warning-box">
                                        <strong>Best Practice:</strong> Avoid complex nesting. If it's hard to read at a
                                        glance, stick to a standard <code>if-else</code> block for clarity.
                                    </div>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li>The ternary operator <code>? :</code> is a concise replacement for
                                                simple <code>if-else</code> blocks.</li>
                                            <li>Syntax: <code>condition ? trueVal : falseVal</code>.</li>
                                            <li>Both return values must be of compatible data types.</li>
                                            <li>Use it for simple assignments to improve readability; avoid it for
                                                complex logic.</li>
                                        </ul>
                                    </div>

                                    <div style="margin-top: 3rem;">
                                        <% String prevLinkUrl=request.getContextPath()
                                            + "/tutorials/java/operators-assignment.jsp" ; String
                                            nextLinkUrl=request.getContextPath()
                                            + "/tutorials/java/operators-precedence.jsp" ; %>
                                            <jsp:include page="../tutorial-nav.jsp">
                                                <jsp:param name="prevLink" value="<%=prevLinkUrl%>" />
                                                <jsp:param name="prevTitle" value="Assignment Operators" />
                                                <jsp:param name="nextLink" value="<%=nextLinkUrl%>" />
                                                <jsp:param name="nextTitle" value="Operator Precedence →" />
                                                <jsp:param name="currentLessonId" value="operators-ternary" />
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