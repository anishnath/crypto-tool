<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "operators-precedence" );
        request.setAttribute("currentModule", "Operators & Expressions" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Java Operator Precedence - Java Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Understand Java's operator precedence and associativity rules. Learn which operations are evaluated first and how to control order with parentheses.">
            <meta name="keywords"
                content="java operator precedence, java order of operations, java operator associativity, PEMDAS in java, expression evaluation">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Java Operator Precedence - Java Tutorial | 8gwifi.org">
            <meta property="og:description"
                content="Master the order of operations in Java to avoid logical errors in complex expressions.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/java/operators-precedence.jsp">
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
    "name": "Java Operator Precedence",
    "description": "Guide to Java operator precedence and associativity.",
    "learningResourceType": "tutorial",
    "educationalLevel": "Beginner",
    "teaches": ["Operator Precedence", "Associativity", "Order of Evaluation"],
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

        <body class="tutorial-body no-preview" data-lesson="operators-precedence">
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
                                    <span>Operator Precedence</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Operator Precedence</h1>
                                    <div class="lesson-meta">
                                        <span>Beginner</span>
                                        <span>~15 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">When an expression has multiple operators (e.g.,
                                        <code>5 + 2 * 3</code>), Java needs to know which one to calculate first. This
                                        is determined by <strong>operator precedence</strong>.
                                    </p>

                                    <!-- Section 1: The Concept -->
                                    <h2>Why It Matters</h2>
                                    <p>Just like in math class (PEMDAS), multiplication happens before addition.</p>
                                    <pre><code class="language-java">int x = 5 + 2 * 3; 
// 2 * 3 = 6
// 5 + 6 = 11
// Result: 11 (NOT 21)</code></pre>

                                    <img src="<%=request.getContextPath()%>/tutorials/assets/images/java-operator-precedence.svg"
                                        alt="Java Operator Precedence Table" class="diagram-image"
                                        style="max-width: 650px; margin: 2rem auto; display: block;">

                                    <!-- Section 2: Precedence Table -->
                                    <h2>Precedence & Associativity Table</h2>
                                    <p>Operators at the top are evaluated first.</p>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Category</th>
                                                <th>Operators</th>
                                                <th>Associativity</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>Postfix</td>
                                                <td><code>expr++</code> <code>expr--</code></td>
                                                <td>Left to Right</td>
                                            </tr>
                                            <tr>
                                                <td>Unary</td>
                                                <td><code>++expr</code> <code>--expr</code> <code>+expr</code>
                                                    <code>-expr</code> <code>~</code> <code>!</code>
                                                </td>
                                                <td>Right to Left</td>
                                            </tr>
                                            <tr>
                                                <td>Multiplicative</td>
                                                <td><code>*</code> <code>/</code> <code>%</code></td>
                                                <td>Left to Right</td>
                                            </tr>
                                            <tr>
                                                <td>Additive</td>
                                                <td><code>+</code> <code>-</code></td>
                                                <td>Left to Right</td>
                                            </tr>
                                            <tr>
                                                <td>Shift</td>
                                                <td><code><<</code> <code>>></code> <code>>>></code></td>
                                                <td>Left to Right</td>
                                            </tr>
                                            <tr>
                                                <td>Relational</td>
                                                <td><code><</code> <code>></code> <code><=</code> <code>>=</code>
                                                    <code>instanceof</code>
                                                </td>
                                                <td>Left to Right</td>
                                            </tr>
                                            <tr>
                                                <td>Equality</td>
                                                <td><code>==</code> <code>!=</code></td>
                                                <td>Left to Right</td>
                                            </tr>
                                            <tr>
                                                <td>Bitwise AND</td>
                                                <td><code>&</code></td>
                                                <td>Left to Right</td>
                                            </tr>
                                            <tr>
                                                <td>Bitwise XOR</td>
                                                <td><code>^</code></td>
                                                <td>Left to Right</td>
                                            </tr>
                                            <tr>
                                                <td>Bitwise OR</td>
                                                <td><code>|</code></td>
                                                <td>Left to Right</td>
                                            </tr>
                                            <tr>
                                                <td>Logical AND</td>
                                                <td><code>&&</code></td>
                                                <td>Left to Right</td>
                                            </tr>
                                            <tr>
                                                <td>Logical OR</td>
                                                <td><code>||</code></td>
                                                <td>Left to Right</td>
                                            </tr>
                                            <tr>
                                                <td>Ternary</td>
                                                <td><code>? :</code></td>
                                                <td>Right to Left</td>
                                            </tr>
                                            <tr>
                                                <td>Assignment</td>
                                                <td><code>=</code> <code>+=</code> <code>-=</code> <code>*=</code> etc
                                                </td>
                                                <td>Right to Left</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="java/OperatorPrecedence.java" />
                                        <jsp:param name="language" value="java" />
                                        <jsp:param name="editorId" value="compiler-precedence" />
                                    </jsp:include>

                                    <!-- Section 3: Using Parentheses -->
                                    <h2>Controlling Order with Parentheses</h2>
                                    <p>Parentheses <code>()</code> have the highest precedence. You can use them to
                                        force evaluations in the order you want.</p>

                                    <div class="tip-box">
                                        <strong>Best Practice:</strong> Don't rely on remembering the entire precedence
                                        table. If an expression is complex, <strong>use parentheses</strong> to make
                                        your intent clear.
                                        <br>
                                        <code>a + b * c</code> vs <code>a + (b * c)</code>
                                    </div>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li>Operators with higher precedence are evaluated first.</li>
                                            <li>Multiplication/Division happen before Addition/Subtraction.</li>
                                            <li>Assignment <code>=</code> has very low precedence (happens last).</li>
                                            <li>Use <strong>parentheses</strong> <code>()</code> to explicitly define
                                                the order of operations and improve code readability.</li>
                                        </ul>
                                    </div>

                                    <div style="margin-top: 3rem;">
                                        <% String prevLinkUrl=request.getContextPath()
                                            + "/tutorials/java/operators-ternary.jsp" ; String
                                            nextLinkUrl=request.getContextPath() + "/tutorials/java/control-if.jsp" ; %>
                                            <jsp:include page="../tutorial-nav.jsp">
                                                <jsp:param name="prevLink" value="<%=prevLinkUrl%>" />
                                                <jsp:param name="prevTitle" value="Ternary Operator" />
                                                <jsp:param name="nextLink" value="<%=nextLinkUrl%>" />
                                                <jsp:param name="nextTitle" value="Next Module: Control Flow →" />
                                                <jsp:param name="currentLessonId" value="operators-precedence" />
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