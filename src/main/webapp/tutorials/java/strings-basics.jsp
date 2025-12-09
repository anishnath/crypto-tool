<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "strings-basics" );
        request.setAttribute("currentModule", "Variables & Data Types" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Java Strings: Immutability, Pool & Methods - Java Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Learn about Java Strings, how they are stored in memory (String Pool), why they are immutable, and explore common String methods with interactive examples.">
            <meta name="keywords"
                content="java string, string pool, string immutability, java string methods, string vs new string, java string comparison">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Java Strings: Immutability & Methods - Java Tutorial | 8gwifi.org">
            <meta property="og:description"
                content="Deep dive into Java Strings: String Pool, Immutability, and powerful built-in methods.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/java/strings-basics.jsp">
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
        "name": "Java Strings",
        "description": "Learn about Java Strings, memory management, and methods.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Beginner",
        "teaches": ["String class", "String Pool", "Immutability", "String methods"],
        "timeRequired": "PT30M",
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

        <body class="tutorial-body no-preview" data-lesson="strings-basics">
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
                                    <span>Strings</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Java Strings</h1>
                                    <div class="lesson-meta">
                                        <span>Beginner</span>
                                        <span>~30 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">In Java, a <strong>String</strong> is not a primitive type like
                                        <code>int</code> or <code>char</code>. It is an <strong>Object</strong> that
                                        represents a sequence of characters. Because handling text is so common, Java
                                        treats Strings specially, giving them their own memory area called the "String
                                        Constant Pool."
                                    </p>

                                    <!-- Section 1: Creating Strings -->
                                    <h2>Creating Strings</h2>
                                    <p>There are two ways to create a String object:</p>
                                    <ol>
                                        <li><strong>String Literal:</strong> <code>String s = "Hello";</code> (Stored in
                                            String Pool)</li>
                                        <li><strong>new Keyword:</strong> <code>String s = new String("Hello");</code>
                                            (Stored in Heap)</li>
                                    </ol>

                                    <div class="tip-box">
                                        <strong>Best Practice:</strong> Always use String literals
                                        (<code>String s = "Hello"</code>). It allows Java to optimize memory by reusing
                                        identical strings from the pool.
                                    </div>

                                    <!-- Section 2: Immutability -->
                                    <h2>String Immutability</h2>
                                    <p>Strings in Java are <strong>immutable</strong> (unchangeable). Once a String
                                        object is created, its data cannot be changed. If you try to modify it, Java
                                        creates a <em>new</em> String object instead.</p>

                                    <img src="<%=request.getContextPath()%>/tutorials/assets/images/java-string-immutability.svg"
                                        alt="Java String Pool and Immutability Diagram" class="diagram-image"
                                        style="max-width: 800px; margin: 2rem auto; display: block;">

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="java/strings-basics.java" />
                                        <jsp:param name="language" value="java" />
                                        <jsp:param name="editorId" value="compiler-strings" />
                                    </jsp:include>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <!-- Section 3: String Comparison -->
                                    <h2>Comparing Strings</h2>
                                    <p>Comparing strings can be tricky because they are objects.</p>
                                    <ul>
                                        <li><code>==</code> compares <strong>references</strong> (memory address). Are
                                            they the exact same object?</li>
                                        <li><code>.equals()</code> compares <strong>content</strong> (values). Do they
                                            have the same characters?</li>
                                    </ul>

                                    <div class="warning-box">
                                        <strong>Common Mistake:</strong> Never compare strings with <code>==</code>
                                        unless you specifically check for identity. Always use
                                        <code>str1.equals(str2)</code> to check if the text is the same.
                                    </div>

                                    <!-- Section 4: Common Methods -->
                                    <h2>Common String Methods</h2>
                                    <p>The String class provides many useful methods for text manipulation.</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="java/strings-methods.java" />
                                        <jsp:param name="language" value="java" />
                                        <jsp:param name="editorId" value="compiler-methods" />
                                    </jsp:include>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>String</strong> is an object, not a primitive type.</li>
                                            <li>Strings are <strong>immutable</strong>; they cannot be changed once
                                                created.</li>
                                            <li>String literals are stored in the <strong>String Constant Pool</strong>
                                                for memory efficiency.</li>
                                            <li>Always use <code>.equals()</code> to compare String content, not
                                                <code>==</code>.
                                            </li>
                                        </ul>
                                    </div>

                                    <!-- What's Next -->
                                    <h2>What's Next?</h2>
                                    <p>Strings allow us to store a sequence of characters. But what if we want to store
                                        a sequence of numbers, or names, or any other data type? That's where
                                        <strong>Arrays</strong> come in. Let's learn about them next.
                                    </p>

                                    <div style="margin-top: 3rem;">
                                        <% String nextLinkUrl=request.getContextPath()
                                            + "/tutorials/java/arrays-basics.jsp" ; String
                                            prevLinkUrl=request.getContextPath() + "/tutorials/java/types-casting.jsp" ;
                                            %>
                                            <jsp:include page="../tutorial-nav.jsp">
                                                <jsp:param name="prevLink" value="<%=prevLinkUrl%>" />
                                                <jsp:param name="prevTitle" value="Type Casting" />
                                                <jsp:param name="nextLink" value="<%=nextLinkUrl%>" />
                                                <jsp:param name="nextTitle" value="Arrays →" />
                                                <jsp:param name="currentLessonId" value="strings-basics" />
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