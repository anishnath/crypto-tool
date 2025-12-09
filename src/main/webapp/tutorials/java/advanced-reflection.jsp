<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "advanced-reflection" );
        request.setAttribute("currentModule", "Advanced Topics" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Java Reflection - Java Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Learn about Java Reflection. Inspect classes, methods, and fields at runtime. Access private members dynamically.">
            <meta name="keywords"
                content="java reflection, java class object, getmethod java, setaccessible true, java runtime inspection">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Java Reflection - Java Tutorial | 8gwifi.org">
            <meta property="og:description" content="Inspect and modify code behavior at runtime with Java Reflection.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/java/advanced-reflection.jsp">
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
    "name": "Java Reflection",
    "description": "Guide to using Reflection in Java.",
    "learningResourceType": "tutorial",
    "educationalLevel": "Advanced",
    "teaches": ["Class Object", "Inspecting Methods", "Accessing Private Fields"],
    "timeRequired": "PT25M",
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

        <body class="tutorial-body no-preview" data-lesson="advanced-reflection">
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
                                    <span>Reflection</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Reflection</h1>
                                    <div class="lesson-meta">
                                        <span>Advanced</span>
                                        <span>~25 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead"><strong>Reflection</strong> allows code to inspect other code
                                        (classes, interfaces, fields, and methods) at runtime, without knowing the names
                                        of the interfaces, fields, methods at compile time.</p>

                                    <!-- Section 1: The Class Object -->
                                    <h2>The <code>Class</code> Object</h2>
                                    <p>Every type in Java including primitive types has an associated <code>Class</code>
                                        object.</p>
                                    <pre><code class="language-java">Class&lt;?&gt; c = Class.forName("java.util.ArrayList");
System.out.println(c.getName());</code></pre>

                                    <!-- Section 2: Inspecting Methods -->
                                    <h2>Inspecting Methods</h2>
                                    <pre><code class="language-java">Method[] methods = c.getMethods();
for (Method m : methods) {
    System.out.println(m.getName());
}</code></pre>

                                    <!-- Section 3: Accessing Private Fields -->
                                    <h2>Accessing Private Fields (The Hacker Way)</h2>
                                    <p>Reflection can break encapsulation by accessing private fields.</p>
                                    <pre><code class="language-java">Field f = myObj.getClass().getDeclaredField("privateField");
f.setAccessible(true); // Unlock it!
System.out.println(f.get(myObj));</code></pre>

                                    <!-- Section 4: Example -->
                                    <h2>Full Example</h2>
                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="java/ReflectionExample.java" />
                                        <jsp:param name="language" value="java" />
                                        <jsp:param name="editorId" value="compiler-reflection" />
                                    </jsp:include>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li>Reflection is powerful but slow. Avoid it in performance-critical loops.
                                            </li>
                                            <li>It can break security and design principles (like private
                                                encapsulation).</li>
                                            <li>Extensively used by Frameworks (Spring, Hibernate, JUnit).</li>
                                        </ul>
                                    </div>

                                    <div style="margin-top: 3rem;">
                                        <% 
                                            // End of tutorials? Or link to home?
                                            String prevLinkUrl = request.getContextPath() + "/tutorials/java/advanced-annotations.jsp"; 
                                            String nextLinkUrl = request.getContextPath() + "/tutorials/java/advanced-regex.jsp"; 
                                        %>
                                            <jsp:include page="../tutorial-nav.jsp">
                                                <jsp:param name="prevLink" value="<%=prevLinkUrl%>" />
                                                <jsp:param name="prevTitle" value="Annotations" />
                                                <jsp:param name="nextLink" value="<%=nextLinkUrl%>" />
                                                <jsp:param name="nextTitle" value="Regular Expressions →" />
                                                <jsp:param name="currentLessonId" value="advanced-reflection" />
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