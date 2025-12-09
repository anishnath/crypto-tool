<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "operators-bitwise" );
        request.setAttribute("currentModule", "Operators & Expressions" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Java Bitwise Operators (&, |, ^, ~) - Java Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Learn how to manipulate individual bits in Java using bitwise AND, OR, XOR, NOT, and shift operators. Understanding binary arithmetic.">
            <meta name="keywords"
                content="java bitwise operators, java bit shift, java AND operator, java OR operator, java XOR operator, java bit masking">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Java Bitwise Operators - Java Tutorial | 8gwifi.org">
            <meta property="og:description"
                content="Master low-level bit manipulation in Java with interactive examples and visual diagrams.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/java/operators-bitwise.jsp">
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
    "name": "Java Bitwise Operators",
    "description": "Guide to Java bitwise operators for manipulating binary data.",
    "learningResourceType": "tutorial",
    "educationalLevel": "Intermediate",
    "teaches": ["Bitwise AND", "Bitwise OR", "Bitwise XOR", "Bit Shifting"],
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

        <body class="tutorial-body no-preview" data-lesson="operators-bitwise">
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
                                    <span>Bitwise Operators</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Bitwise Operators</h1>
                                    <div class="lesson-meta">
                                        <span>Intermediate</span>
                                        <span>~20 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">Bitwise operators work directly on the binary representation of
                                        integers. While less common in high-level business logic, they are crucial for
                                        cryptography, network protocols, and optimizing performance.</p>

                                    <!-- Section 1: The Operators -->
                                    <h2>Bitwise Operations</h2>
                                    <p>These operators perform operations on each individual bit of the operands.</p>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Operator</th>
                                                <th>Name</th>
                                                <th>Description</th>
                                                <th>Example (A=5, B=3)</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><code>&</code></td>
                                                <td>Bitwise AND</td>
                                                <td>1 if both bits are 1</td>
                                                <td><code>5 & 3</code> = 1 (0101 & 0011 = 0001)</td>
                                            </tr>
                                            <tr>
                                                <td><code>|</code></td>
                                                <td>Bitwise OR</td>
                                                <td>1 if at least one bit is 1</td>
                                                <td><code>5 | 3</code> = 7 (0101 | 0011 = 0111)</td>
                                            </tr>
                                            <tr>
                                                <td><code>^</code></td>
                                                <td>Bitwise XOR</td>
                                                <td>1 if bits are different</td>
                                                <td><code>5 ^ 3</code> = 6 (0101 ^ 0011 = 0110)</td>
                                            </tr>
                                            <tr>
                                                <td><code>~</code></td>
                                                <td>Bitwise Compliment</td>
                                                <td>Inverts all bits (0s become 1s)</td>
                                                <td><code>~5</code> = -6 (conceptually)</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <img src="<%=request.getContextPath()%>/tutorials/assets/images/java-bitwise-ops.svg"
                                        alt="Java Bitwise Operations Diagram" class="diagram-image"
                                        style="max-width: 600px; margin: 2rem auto; display: block;">

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="java/BitwiseOperators.java" />
                                        <jsp:param name="language" value="java" />
                                        <jsp:param name="editorId" value="compiler-bitwise" />
                                    </jsp:include>

                                    <!-- Section 2: Shift Operators -->
                                    <h2>Bit Shift Operators</h2>
                                    <p>Shift operators move the bits of a number to the left or right.</p>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Operator</th>
                                                <th>Name</th>
                                                <th>Description</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><code>&lt;&lt;</code></td>
                                                <td>Left Shift</td>
                                                <td>Shifts bits left, filling with 0s. (Multiplies by 2)</td>
                                            </tr>
                                            <tr>
                                                <td><code>&gt;&gt;</code></td>
                                                <td>Signed Right Shift</td>
                                                <td>Shifts bits right, preserving the sign bit. (Divides by 2)</td>
                                            </tr>
                                            <tr>
                                                <td><code>&gt;&gt;&gt;</code></td>
                                                <td>Unsigned Right Shift</td>
                                                <td>Shifts bits right, filling with 0s (ignoring sign).</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <div class="info-box">
                                        <strong>Performance Tip:</strong> Shifting left by 1 (<code>x << 1</code>) is
                                        equivalent to multiplying by 2. Shifting right by 1 (<code>x >> 1</code>) is
                                        equivalent to integer division by 2. This was used historically for performance,
                                        but modern compilers optimize standard multiplication/division just as well.
                                    </div>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li>Bitwise operators evaluate numbers at the binary level.</li>
                                            <li><code>&</code>, <code>|</code>, <code>^</code> work similarly to logical
                                                operators but on bits.</li>
                                            <li><code>&lt;&lt;</code> shifts bits left (multiply by 2^n).</li>
                                            <li><code>&gt;&gt;</code> shifts bits right (divide by 2^n), preserving
                                                sign.</li>
                                            <li>Use <code>Integer.toBinaryString()</code> to inspect binary values in
                                                code.</li>
                                        </ul>
                                    </div>

                                    <div style="margin-top: 3rem;">
                                        <% String prevLinkUrl=request.getContextPath()
                                            + "/tutorials/java/operators-logical.jsp" ; String
                                            nextLinkUrl=request.getContextPath()
                                            + "/tutorials/java/operators-assignment.jsp" ; %>
                                            <jsp:include page="../tutorial-nav.jsp">
                                                <jsp:param name="prevLink" value="<%=prevLinkUrl%>" />
                                                <jsp:param name="prevTitle" value="Logical Operators" />
                                                <jsp:param name="nextLink" value="<%=nextLinkUrl%>" />
                                                <jsp:param name="nextTitle" value="Assignment Operators →" />
                                                <jsp:param name="currentLessonId" value="operators-bitwise" />
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