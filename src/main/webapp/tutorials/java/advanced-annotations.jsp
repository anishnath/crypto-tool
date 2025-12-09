<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "advanced-annotations" );
        request.setAttribute("currentModule", "Advanced Topics" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Java Annotations - Java Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Learn about Java Annotations. Understand built-in annotations like @Override and @Deprecated, and how to create custom annotations.">
            <meta name="keywords"
                content="java annotations, java override, java deprecated, custom annotation java, java metadata">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Java Annotations - Java Tutorial | 8gwifi.org">
            <meta property="og:description" content="Understand metadata in Java with Annotations.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/java/advanced-annotations.jsp">
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
    "name": "Java Annotations",
    "description": "Guide to using Annotations in Java.",
    "learningResourceType": "tutorial",
    "educationalLevel": "Intermediate",
    "teaches": ["Built-in Annotations", "Custom Annotations", "Metadata"],
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

        <body class="tutorial-body no-preview" data-lesson="advanced-annotations">
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
                                    <span>Annotations</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Annotations</h1>
                                    <div class="lesson-meta">
                                        <span>Intermediate</span>
                                        <span>~15 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead"><strong>Annotations</strong> provide metadata (data about data) for
                                        our code. They do not change the action of a compiled program directly but are
                                        used by compilers and tools.</p>

                                    <!-- Section 1: Built-in Annotations -->
                                    <h2>Built-in Annotations</h2>
                                    <p>Java has several built-in annotations:</p>
                                    <ul>
                                        <li><code>@Override</code>: Ensures a method is overriding a parent method.</li>
                                        <li><code>@Deprecated</code>: Marks a method/class as obsolete.</li>
                                        <li><code>@SuppressWarnings</code>: Tells the compiler to ignore specific
                                            warnings.</li>
                                    </ul>

                                    <pre><code class="language-java">@Override
public String toString() {
    return "My Object";
}

@Deprecated
public void oldMethod() { }</code></pre>

                                    <!-- Section 2: Custom Annotations -->
                                    <h2>Creating Custom Annotations</h2>
                                    <p>You can create your own annotations using the <code>@interface</code> keyword.
                                    </p>
                                    <pre><code class="language-java">@interface MyAnnotation {
    String value();
    int version() default 1;
}

@MyAnnotation(value = "Test", version = 2)
public void myMethod() { }</code></pre>

                                    <!-- Section 3: Example -->
                                    <h2>Full Example</h2>
                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="java/AnnotationExample.java" />
                                        <jsp:param name="language" value="java" />
                                        <jsp:param name="editorId" value="compiler-annotations" />
                                    </jsp:include>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li>Annotations start with <code>@</code>.</li>
                                            <li>Use <code>@Override</code> to prevent bugs when overriding methods.</li>
                                            <li>Annotations can be processed at runtime using
                                                <strong>Reflection</strong> (next lesson).</li>
                                        </ul>
                                    </div>

                                    <div style="margin-top: 3rem;">
                                        <% String prevLinkUrl=request.getContextPath()
                                            + "/tutorials/java/advanced-enums.jsp" ; String
                                            nextLinkUrl=request.getContextPath()
                                            + "/tutorials/java/advanced-reflection.jsp" ; %>
                                            <jsp:include page="../tutorial-nav.jsp">
                                                <jsp:param name="prevLink" value="<%=prevLinkUrl%>" />
                                                <jsp:param name="prevTitle" value="Enums" />
                                                <jsp:param name="nextLink" value="<%=nextLinkUrl%>" />
                                                <jsp:param name="nextTitle" value="Reflection →" />
                                                <jsp:param name="currentLessonId" value="advanced-annotations" />
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