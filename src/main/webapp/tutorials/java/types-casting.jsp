<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "types-casting" );
        request.setAttribute("currentModule", "Variables & Data Types" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Java Type Casting (Widening & Narrowing) - Java Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Learn about Type Casting in Java. Understand the difference between Widening (Implicit) and Narrowing (Explicit) casting, and how to safe-guard against data loss.">
            <meta name="keywords"
                content="java type casting, widening casting, narrowing casting, type conversion, java casting examples, implicit vs explicit casting">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Java Type Casting - Java Tutorial | 8gwifi.org">
            <meta property="og:description"
                content="Master Java Type Casting: Convert between data types safely and effectively.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/java/types-casting.jsp">
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
        "name": "Java Type Casting",
        "description": "Learn about Widening and Narrowing Type Casting in Java.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Beginner",
        "teaches": ["Widening Casting", "Narrowing Casting", "Type Promotion", "Data Loss"],
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

        <body class="tutorial-body no-preview" data-lesson="types-casting">
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
                                    <span>Type Casting</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Java Type Casting</h1>
                                    <div class="lesson-meta">
                                        <span>Beginner</span>
                                        <span>~20 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">Type casting is when you assign a value of one primitive data type
                                        to another type. In Java, this process can happen automatically or require
                                        manual intervention, depending on whether you are moving from a smaller type to
                                        a larger one, or vice-versa.</p>

                                    <!-- Section 1: Types of Casting -->
                                    <h2>Types of Casting</h2>
                                    <p>There are two types of casting in Java:</p>

                                    <img src="<%=request.getContextPath()%>/tutorials/assets/images/java-type-casting.svg"
                                        alt="Widening vs Narrowing Casting" class="diagram-image"
                                        style="max-width: 800px; margin: 2rem auto; display: block;">

                                    <h3>1. Widening Casting (Automatic)</h3>
                                    <p>Converting a smaller type to a larger type size. Java handles this automatically
                                        because there is no risk of losing data.</p>
                                    <p>Order: <code>byte</code> &rarr; <code>short</code> &rarr; <code>char</code>
                                        &rarr; <code>int</code> &rarr; <code>long</code> &rarr; <code>float</code>
                                        &rarr; <code>double</code></p>

                                    <h3>2. Narrowing Casting (Manual)</h3>
                                    <p>Converting a larger type to a smaller size type. You must do this manually by
                                        placing the type in parentheses in front of the value. This is risky because
                                        data might be lost.</p>
                                    <p>Order: <code>double</code> &rarr; <code>float</code> &rarr; <code>long</code>
                                        &rarr; <code>int</code> &rarr; <code>char</code> &rarr; <code>short</code>
                                        &rarr; <code>byte</code></p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="java/types-casting.java" />
                                        <jsp:param name="language" value="java" />
                                        <jsp:param name="editorId" value="compiler-casting" />
                                    </jsp:include>

                                    <!-- Section 2: Real World Example -->
                                    <h2>Why do we need casting?</h2>
                                    <p>A common scenario is calculating a percentage or average. Even if the inputs are
                                        integers, the result should likely be a decimal (double).</p>

                                    <pre><code class="language-java">int maxScore = 500;
int userScore = 423;

// Problem: Integer division results in 0
double percentage = userScore / maxScore * 100.0; // Wait, this might be 0.0!

// Solution: Cast one operand to double first
double correctPercentage = (double) userScore / maxScore * 100.0;</code></pre>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <!-- Section 3: Type Promotion -->
                                    <h2>Type Promotion in Expressions</h2>
                                    <p>When evaluating expressions, Java automatically promotes smaller types to larger
                                        types to perform the calculation. This can sometimes lead to compilation errors
                                        if you try to store the result back into a smaller variable.</p>

                                    <div class="info-box">
                                        <strong>Rules of Promotion:</strong>
                                        <ol>
                                            <li><code>byte</code>, <code>short</code>, and <code>char</code> operands
                                                are always promoted to <code>int</code>.</li>
                                            <li>If any operand is <code>long</code>, the whole expression is promoted to
                                                <code>long</code>.
                                            </li>
                                            <li>If any operand is <code>float</code>, the whole expression is promoted
                                                to <code>float</code>.</li>
                                            <li>If any operand is <code>double</code>, the whole expression is promoted
                                                to <code>double</code>.</li>
                                        </ol>
                                    </div>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="java/types-casting-examples.java" />
                                        <jsp:param name="language" value="java" />
                                        <jsp:param name="editorId" value="compiler-promotion" />
                                    </jsp:include>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>Widening Casting</strong> (small &rarr; large) is automatic and
                                                safe.</li>
                                            <li><strong>Narrowing Casting</strong> (large &rarr; small) requires manual
                                                syntax: <code>(targetType) variable</code>.</li>
                                            <li>Be careful with data loss (truncation) when narrowing.</li>
                                            <li>Arithmetic expressions automatically promote types (e.g., byte + byte =
                                                int).</li>
                                        </ul>
                                    </div>

                                    <!-- What's Next -->
                                    <h2>What's Next?</h2>
                                    <p>Primitive types are great, but what about text? In Java, text is handled by the
                                        <strong>String</strong> class, which is not a primitive type but a powerful
                                        object. Let's explore Strings in the next lesson.
                                    </p>

                                    <div style="margin-top: 3rem;">
                                        <% String nextLinkUrl=request.getContextPath()
                                            + "/tutorials/java/strings-basics.jsp" ; String
                                            prevLinkUrl=request.getContextPath()
                                            + "/tutorials/java/variables-declaration.jsp" ; %>
                                            <jsp:include page="../tutorial-nav.jsp">
                                                <jsp:param name="prevLink" value="<%=prevLinkUrl%>" />
                                                <jsp:param name="prevTitle" value="Variables" />
                                                <jsp:param name="nextLink" value="<%=nextLinkUrl%>" />
                                                <jsp:param name="nextTitle" value="Strings →" />
                                                <jsp:param name="currentLessonId" value="types-casting" />
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