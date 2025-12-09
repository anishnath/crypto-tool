<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "operators-assignment" );
        request.setAttribute("currentModule", "Operators & Expressions" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Java Assignment Operators (=, +=, -=) - Java Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Learn how to assign values to variables in Java using assignment operators. Understand compound assignments like +=, -=, *=, and their hidden casting rules.">
            <meta name="keywords"
                content="java assignment operators, java compound assignment, java addition assignment, java hidden casting, java variable assignment">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Java Assignment Operators - Java Tutorial | 8gwifi.org">
            <meta property="og:description"
                content="Master Java's assignment operators including compound assignments and their special type casting behavior.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/java/operators-assignment.jsp">
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
    "name": "Java Assignment Operators",
    "description": "Guide to Java assignment operators and compound assignments.",
    "learningResourceType": "tutorial",
    "educationalLevel": "Beginner",
    "teaches": ["Assignment Operator", "Compound Assignment", "Type Casting in Assignments"],
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

        <body class="tutorial-body no-preview" data-lesson="operators-assignment">
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
                                    <span>Assignment Operators</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Assignment Operators</h1>
                                    <div class="lesson-meta">
                                        <span>Beginner</span>
                                        <span>~10 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">Assignment operators are used to assign values to variables. While
                                        the basic equals sign <code>=</code> is the most common, Java offers "compound"
                                        assignment operators that perform a math operation and assignment in one step.
                                    </p>

                                    <!-- Section 1: The Operators -->
                                    <h2>Assignment Operators List</h2>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Operator</th>
                                                <th>Example</th>
                                                <th>Equivalent To</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><code>=</code></td>
                                                <td><code>x = 5</code></td>
                                                <td>x = 5</td>
                                            </tr>
                                            <tr>
                                                <td><code>+=</code></td>
                                                <td><code>x += 3</code></td>
                                                <td><code>x = x + 3</code></td>
                                            </tr>
                                            <tr>
                                                <td><code>-=</code></td>
                                                <td><code>x -= 3</code></td>
                                                <td><code>x = x - 3</code></td>
                                            </tr>
                                            <tr>
                                                <td><code>*=</code></td>
                                                <td><code>x *= 3</code></td>
                                                <td><code>x = x * 3</code></td>
                                            </tr>
                                            <tr>
                                                <td><code>/=</code></td>
                                                <td><code>x /= 3</code></td>
                                                <td><code>x = x / 3</code></td>
                                            </tr>
                                            <tr>
                                                <td><code>%=</code></td>
                                                <td><code>x %= 3</code></td>
                                                <td><code>x = x % 3</code></td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="java/AssignmentOperators.java" />
                                        <jsp:param name="language" value="java" />
                                        <jsp:param name="editorId" value="compiler-assignment" />
                                    </jsp:include>

                                    <!-- Section 2: Type Casting Nuance -->
                                    <h2>Hidden Type Casting</h2>
                                    <p>Compound assignment operators like <code>+=</code> have a special feature: they
                                        automatically perform a type cast.</p>

                                    <div class="info-box">
                                        <p>Consider adding an <code>int</code> to a <code>byte</code> (remember, byte +
                                            int results in int):</p>

                                        <pre><code class="language-java">byte b = 10;
// b = b + 1;  // Compile ERROR! (int cannot be converted to byte) 

// Correct way with explicit cast:
b = (byte)(b + 1);

// SHORTCUT with +=
b += 1;  // Works! Cast is implicit.</code></pre>

                                        <p>The compiler treats <code>E1 op= E2</code> as
                                            <code>E1 = (Type of E1)(E1 op E2)</code>.</p>
                                    </div>

                                    <div class="warning-box">
                                        <strong>Watch Out:</strong> Because of hidden casting, you might trigger an
                                        overflow without realizing it!
                                        <br><code>byte b = 127; b += 1; // b becomes -128 (overflow)</code>
                                    </div>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li>Use <code>=</code> to assign a value.</li>
                                            <li>Use <code>+=</code>, <code>-=</code>, etc. for cleaner code when
                                                modifying a variable by a value.</li>
                                            <li>Compound assignment operators automatically handle type casting, which
                                                is convenient but hides potential data loss or overflows.</li>
                                        </ul>
                                    </div>

                                    <div style="margin-top: 3rem;">
                                        <% String prevLinkUrl=request.getContextPath()
                                            + "/tutorials/java/operators-bitwise.jsp" ; String
                                            nextLinkUrl=request.getContextPath()
                                            + "/tutorials/java/operators-ternary.jsp" ; %>
                                            <jsp:include page="../tutorial-nav.jsp">
                                                <jsp:param name="prevLink" value="<%=prevLinkUrl%>" />
                                                <jsp:param name="prevTitle" value="Bitwise Operators" />
                                                <jsp:param name="nextLink" value="<%=nextLinkUrl%>" />
                                                <jsp:param name="nextTitle" value="Ternary Operator →" />
                                                <jsp:param name="currentLessonId" value="operators-assignment" />
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