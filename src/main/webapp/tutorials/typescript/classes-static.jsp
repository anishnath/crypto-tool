<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "classes-static" ); request.setAttribute("currentModule", "Classes & OOP"
        ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width,initial-scale=1.0">
            <title>TypeScript Static Members - TypeScript Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Free TypeScript tutorial: master TypeScript static properties and methods for class-level functionality.">
            <link rel="canonical" href="https://8gwifi.org/tutorials/typescript/classes-static.jsp">
            <link rel="icon" type="image/svg+xml"
                href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial-server.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror.min.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/monokai.min.css">
            <script>(function () { var t = localStorage.getItem('tutorial-theme'); if (t === 'dark' || (!t && window.matchMedia('(prefers-color-scheme: dark)').matches)) { document.documentElement.setAttribute('data-theme', 'dark'); } })()</script>
            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        
    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "LearningResource",
        "name": "TypeScript Static Members",
        "description": "Learn static properties and methods for class-level functionality.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Beginner",
        "timeRequired": "PT20M",
        "inLanguage": "en",
        "isAccessibleForFree": true,
        "author": {
            "@type": "Organization",
            "name": "8gwifi.org",
            "url": "https://8gwifi.org"
        },
        "isPartOf": {
            "@type": "Course",
            "name": "TypeScript Tutorial",
            "url": "https://8gwifi.org/tutorials/typescript/"
        },
        "publisher": {
            "@type": "Organization",
            "name": "8gwifi.org",
            "url": "https://8gwifi.org"
        },
        "datePublished": "2025-12-10",
        "dateModified": "2025-12-10"
    }
    </script>
        </head>

        <body class="tutorial-body no-preview" data-lesson="classes-static">
            <div class="tutorial-layout">
                <%@ include file="../tutorial-header.jsp" %>
                    <main class="tutorial-main">
                        <%@ include file="../tutorial-sidebar-typescript.jsp" %>
                            <div class="overlay" id="sidebarOverlay" onclick="toggleSidebar()"></div>
                            <article class="tutorial-content">
                                <nav class="breadcrumb"><a
                                        href="<%=request.getContextPath()%>/tutorials/">Tutorials</a><span
                                        class="breadcrumb-separator">/</span><a
                                        href="<%=request.getContextPath()%>/tutorials/typescript/">TypeScript</a><span
                                        class="breadcrumb-separator">/</span><span>Static Members</span></nav>
                                <header class="lesson-header">
                                    <h1 class="lesson-title">Static Members</h1>
                                    <div class="lesson-meta"><span>Beginner</span><span>~15 min</span></div>
                                </header>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>
                                <div class="lesson-body">
                                    <p class="lead">Static members belong to the class itself, not instances. They're
                                        perfect for utility functions and shared data.</p>

                                    <h2>Static Properties and Methods</h2>
                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="typescript/class-static.ts" />
                                        <jsp:param name="language" value="typescript" />
                                        <jsp:param name="editorId" value="compiler-static" />
                                    </jsp:include>

                                    <div class="info-box"><strong>Static vs Instance:</strong>
                                        <ul>
                                            <li><strong>Static:</strong> Accessed via class name (e.g.,
                                                <code>Math.PI</code>)</li>
                                            <li><strong>Instance:</strong> Accessed via object (e.g.,
                                                <code>user.name</code>)</li>
                                            <li>Static members are shared across all instances</li>
                                            <li>Cannot access instance members from static methods</li>
                                        </ul>
                                    </div>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <h2>When to Use Static</h2>
                                    <ul>
                                        <li><strong>Utility functions:</strong> Math operations, formatters</li>
                                        <li><strong>Constants:</strong> Shared configuration values</li>
                                        <li><strong>Factory methods:</strong> Alternative constructors</li>
                                        <li><strong>Counters:</strong> Track total instances</li>
                                    </ul>

                                    <h2>Common Mistakes</h2>
                                    <div class="mistake-box">
                                        <h4>1. Accessing Instance Members from Static</h4>
                                        <pre><code class="language-typescript">class User {
    userName: string = "Alice";
    
    static greet() {
        console.log(this.userName);  // ✗ Error!
    }
}

// ✓ Static can only access static
class User {
    static defaultName = "Guest";
    
    static greet() {
        console.log(this.defaultName);  // ✓ OK
    }
}</code></pre>

                                        <h4>2. Using 'this' Instead of Class Name</h4>
                                        <pre><code class="language-typescript">class Counter {
    static count = 0;
    
    increment() {
        this.count++;  // ✗ Wrong - 'this' is instance
    }
}

// ✓ Use class name
class Counter {
    static count = 0;
    
    increment() {
        Counter.count++;  // ✓ Correct
    }
}</code></pre>
                                    </div>

                                    <div class="tip-box"><strong>Best Practice:</strong> Use static for utility
                                        functions that don't need instance data. Examples: <code>Math.max()</code>,
                                        <code>Array.isArray()</code></div>

                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li>Static members belong to the class, not instances</li>
                                            <li>Access via class name: <code>ClassName.member</code></li>
                                            <li>Perfect for utilities, constants, factories</li>
                                            <li>Cannot access instance members from static</li>
                                        </ul>
                                    </div>

                                    <h2>What's Next?</h2>
                                    <p>Congratulations! Module 3 complete. Next: <strong>Advanced Types</strong>!</p>

                                    <div style="margin-top:3rem;">
                                        <% String
                                            prevLinkUrl=request.getContextPath()+"/tutorials/typescript/classes-abstract.jsp";String
                                            nextLinkUrl=request.getContextPath()+"/tutorials/typescript/advanced-union.jsp";%>
                                            <jsp:include page="../tutorial-nav.jsp">
                                                <jsp:param name="prevLink" value="<%=prevLinkUrl%>" />
                                                <jsp:param name="prevTitle" value="← Abstract Classes" />
                                                <jsp:param name="nextLink" value="<%=nextLinkUrl%>" />
                                                <jsp:param name="nextTitle" value="Union Types →" />
                                                <jsp:param name="currentLessonId" value="classes-static" />
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
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/javascript.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/progress.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/tutorial-core.js?v=4"></script>
        </body>

        </html>