<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "operators-comparison" );
        request.setAttribute("currentModule", "Operators & Expressions" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Java Comparison Operators (==, !=, >, <) - Java Tutorial | 8gwifi.org</title>
                    <meta name="description"
                        content="Learn how to compare values in Java using comparison operators: equal to, not equal to, greater than, less than, and more. Understanding boolean logic.">
                    <meta name="keywords"
                        content="java comparison operators, java relational operators, java equal to, java not equal, java greater than, java less than, boolean logic">

                    <meta property="og:type" content="article">
                    <meta property="og:title" content="Java Comparison Operators - Java Tutorial | 8gwifi.org">
                    <meta property="og:description"
                        content="Master Java's comparison operators for decision making and boolean logic.">
                    <meta property="og:site_name" content="8gwifi.org Tutorials">

                    <link rel="canonical" href="https://8gwifi.org/tutorials/java/operators-comparison.jsp">
                    <link rel="icon" type="image/svg+xml"
                        href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
                    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
                    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
                    <link rel="stylesheet"
                        href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial-server.css">
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
    "name": "Java Comparison Operators",
    "description": "Guide to Java comparison (relational) operators for comparing values and boolean logic.",
    "learningResourceType": "tutorial",
    "educationalLevel": "Beginner",
    "teaches": ["Comparison operators", "Equality check", "Relational logic", "Boolean results"],
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

        <body class="tutorial-body no-preview" data-lesson="operators-comparison">
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
                                    <span>Comparison Operators</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Comparison Operators</h1>
                                    <div class="lesson-meta">
                                        <span>Beginner</span>
                                        <span>~15 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">Comparison operators (relational operators) are used to compare two
                                        values. The result of any comparison operation is always a <code>boolean</code>
                                        value: either <code>true</code> or <code>false</code>.</p>

                                    <!-- Section 1: The Operators -->
                                    <h2>The 6 Comparison Operators</h2>
                                    <p>Java provides six standard operators for comparing primitive values:</p>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Operator</th>
                                                <th>Name</th>
                                                <th>Example (assume x=5, y=3)</th>
                                                <th>Result</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><code>==</code></td>
                                                <td>Equal to</td>
                                                <td><code>x == y</code></td>
                                                <td><code>false</code></td>
                                            </tr>
                                            <tr>
                                                <td><code>!=</code></td>
                                                <td>Not equal to</td>
                                                <td><code>x != y</code></td>
                                                <td><code>true</code></td>
                                            </tr>
                                            <tr>
                                                <td><code>&gt;</code></td>
                                                <td>Greater than</td>
                                                <td><code>x &gt; y</code></td>
                                                <td><code>true</code></td>
                                            </tr>
                                            <tr>
                                                <td><code>&lt;</code></td>
                                                <td>Less than</td>
                                                <td><code>x &lt; y</code></td>
                                                <td><code>false</code></td>
                                            </tr>
                                            <tr>
                                                <td><code>&gt;=</code></td>
                                                <td>Greater than or equal to</td>
                                                <td><code>x &gt;= y</code></td>
                                                <td><code>true</code></td>
                                            </tr>
                                            <tr>
                                                <td><code>&lt;=</code></td>
                                                <td>Less than or equal to</td>
                                                <td><code>x &lt;= y</code></td>
                                                <td><code>false</code></td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="java/ComparisonOperators.java" />
                                        <jsp:param name="language" value="java" />
                                        <jsp:param name="editorId" value="compiler-comparison" />
                                    </jsp:include>

                                    <!-- Section 2: Important Nuances -->
                                    <h2>Common Pitfalls</h2>

                                    <div class="mistake-box">
                                        <h4>1. Assignment (=) vs Equality (==)</h4>
                                        <p><strong>Problem:</strong> Using a single equals sign <code>=</code> instead
                                            of double equals <code>==</code>.</p>
                                        <pre><code class="language-java">// Wrong
if (x = 5) { ... } // Compiler error! (Assignment, not boolean)

// Correct
if (x == 5) { ... } // Comparison</code></pre>
                                    </div>

                                    <div class="warning-box">
                                        <strong>Comparing Objects:</strong> Be very careful when comparing objects (like
                                        <code>String</code>) with <code>==</code>.
                                        <ul>
                                            <li>For primitives (int, char, boolean), <code>==</code> compares
                                                <strong>values</strong>.</li>
                                            <li>For objects (Strings, Arrays), <code>==</code> compares <strong>memory
                                                    addresses (references)</strong>.</li>
                                        </ul>
                                        <p>To compare String content, always use <code>.equals()</code>.</p>
                                        <pre><code class="language-java">String s1 = "Hello";
String s2 = new String("Hello");

System.out.println(s1 == s2);       // false (different objects)
System.out.println(s1.equals(s2));  // true (same content)</code></pre>
                                    </div>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li>Comparison operators always return a <code>boolean</code> result.</li>
                                            <li>Use <code>==</code> for equality and <code>!=</code> for inequality.
                                            </li>
                                            <li>Use <code>&gt;</code>, <code>&lt;</code>, <code>&gt;=</code>,
                                                <code>&lt;=</code> for range checks.</li>
                                            <li>Do not confuse <code>=</code> (assignment) with <code>==</code>
                                                (equality).</li>
                                            <li>Use <code>.equals()</code> when comparing Strings, not <code>==</code>.
                                            </li>
                                        </ul>
                                    </div>

                                    <div style="margin-top: 3rem;">
                                        <% String prevLinkUrl=request.getContextPath()
                                            + "/tutorials/java/operators-arithmetic.jsp" ; String
                                            nextLinkUrl=request.getContextPath()
                                            + "/tutorials/java/operators-logical.jsp" ; %>
                                            <jsp:include page="../tutorial-nav.jsp">
                                                <jsp:param name="prevLink" value="<%=prevLinkUrl%>" />
                                                <jsp:param name="prevTitle" value="Arithmetic Operators" />
                                                <jsp:param name="nextLink" value="<%=nextLinkUrl%>" />
                                                <jsp:param name="nextTitle" value="Logical Operators →" />
                                                <jsp:param name="currentLessonId" value="operators-comparison" />
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