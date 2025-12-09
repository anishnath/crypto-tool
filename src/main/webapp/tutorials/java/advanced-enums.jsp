<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "advanced-enums" ); request.setAttribute("currentModule", "Advanced Topics"
        ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Java Enums - Java Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Learn about Java Enums. Understand how to define enumerations, use them in switch statements, and add fields and methods to enums.">
            <meta name="keywords" content="java enums, java enumeration, enum example java, enum fields methods">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Java Enums - Java Tutorial | 8gwifi.org">
            <meta property="og:description" content="Master Java Enums for defining constants and more.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/java/advanced-enums.jsp">
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
    "name": "Java Enums",
    "description": "Guide to using Enums in Java.",
    "learningResourceType": "tutorial",
    "educationalLevel": "Intermediate",
    "teaches": ["Defining Enums", "Enums in Switch", "Enum Methods"],
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

        <body class="tutorial-body no-preview" data-lesson="advanced-enums">
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
                                    <span>Enums</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Enums</h1>
                                    <div class="lesson-meta">
                                        <span>Intermediate</span>
                                        <span>~15 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">An <strong>Enum</strong> (short for Enumeration) is a special Java
                                        type used to define collections of constants.</p>

                                    <!-- Section 1: Basic Usage -->
                                    <h2>Defining an Enum</h2>
                                    <pre><code class="language-java">enum Level {
    LOW,
    MEDIUM,
    HIGH
}
Level myVar = Level.MEDIUM;</code></pre>

                                    <!-- Section 2: Enums in Switch -->
                                    <h2>Enums in Switch Statements</h2>
                                    <p>Enums are often used in switch statements to check for corresponding values.</p>
                                    <pre><code class="language-java">switch(myVar) {
    case LOW:
        // ...
        break;
}</code></pre>

                                    <!-- Section 3: Advanced Usage -->
                                    <h2>Enums are Classes</h2>
                                    <p>In Java, enums are real classes. They can have attributes and methods!</p>
                                    <pre><code class="language-java">enum Level {
    LOW(1), MEDIUM(5), HIGH(10); // Constructor calls
    
    private final int value; // Field
    
    Level(int value) { 
        this.value = value; 
    }
    
    public int getValue() { 
        return value; 
    }
}</code></pre>

                                    <!-- Section 4: Example -->
                                    <h2>Full Example</h2>
                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="java/EnumExample.java" />
                                        <jsp:param name="language" value="java" />
                                        <jsp:param name="editorId" value="compiler-enums" />
                                    </jsp:include>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li>Enums represent a fixed set of constants.</li>
                                            <li>They are type-safe and more readable than integer constants.</li>
                                            <li>They can have constructors, fields, and methods.</li>
                                        </ul>
                                    </div>

                                    <div style="margin-top: 3rem;">
                                        <% String prevLinkUrl=request.getContextPath()
                                            + "/tutorials/java/advanced-executors.jsp" ; String
                                            nextLinkUrl=request.getContextPath()
                                            + "/tutorials/java/advanced-annotations.jsp" ; %>
                                            <jsp:include page="../tutorial-nav.jsp">
                                                <jsp:param name="prevLink" value="<%=prevLinkUrl%>" />
                                                <jsp:param name="prevTitle" value="Concurrency Utilities" />
                                                <jsp:param name="nextLink" value="<%=nextLinkUrl%>" />
                                                <jsp:param name="nextTitle" value="Annotations →" />
                                                <jsp:param name="currentLessonId" value="advanced-enums" />
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