<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "classes-constructor" );
        request.setAttribute("currentModule", "Classes & OOP" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>TypeScript Constructors - TypeScript Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Free TypeScript tutorial: master TypeScript constructors and parameter properties for efficient class initialization.">
            <link rel="canonical" href="https://8gwifi.org/tutorials/typescript/classes-constructor.jsp">
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
        "name": "TypeScript Constructors",
        "description": "Master constructors and parameter properties for class initialization.",
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

        <body class="tutorial-body no-preview" data-lesson="classes-constructor">
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
                                        class="breadcrumb-separator">/</span><span>Constructors</span></nav>
                                <header class="lesson-header">
                                    <h1 class="lesson-title">Constructors</h1>
                                    <div class="lesson-meta"><span>Beginner</span><span>~18 min</span></div>
                                </header>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>
                                <div class="lesson-body">
                                    <p class="lead">Constructors initialize class instances. TypeScript's parameter
                                        properties provide a powerful shorthand for declaring and initializing
                                        properties in one step.</p>

                                    <h2>Parameter Properties</h2>
                                    <p>TypeScript's parameter properties eliminate boilerplate code:</p>
                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="typescript/class-param-properties.ts" />
                                        <jsp:param name="language" value="typescript" />
                                        <jsp:param name="editorId" value="compiler-param" />
                                    </jsp:include>

                                    <div class="tip-box"><strong>Best Practice:</strong> Use parameter properties for
                                        simple classes. They reduce code and improve readability.</div>

                                    <h2>Traditional vs Parameter Properties</h2>
                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Approach</th>
                                                <th>Lines of Code</th>
                                                <th>Readability</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>Traditional</td>
                                                <td>~8 lines</td>
                                                <td>Verbose but explicit</td>
                                            </tr>
                                            <tr>
                                                <td>Parameter Properties</td>
                                                <td>~3 lines</td>
                                                <td>Concise and clear</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <h2>Common Mistakes</h2>
                                    <div class="mistake-box">
                                        <h4>1. Mixing Styles</h4>
                                        <pre><code class="language-typescript">// ✗ Confusing - mixing both styles
class User {
    email: string;
    constructor(public userName: string, email: string) {
        this.email = email;
    }
}

// ✓ Consistent - all parameter properties
class User {
    constructor(
        public userName: string,
        public email: string
    ) {}
}</code></pre>

                                        <h4>2. Forgetting Access Modifier</h4>
                                        <pre><code class="language-typescript">// ✗ Wrong - no access modifier = not a property
class User {
    constructor(userName: string) {}  // Just a parameter!
}

// ✓ Correct - public makes it a property
class User {
    constructor(public userName: string) {}
}</code></pre>
                                    </div>

                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li>Parameter properties reduce boilerplate</li>
                                            <li>Add access modifier (public/private/protected) to parameters</li>
                                            <li>Properties are automatically created and initialized</li>
                                            <li>Use consistently within a class</li>
                                        </ul>
                                    </div>

                                    <h2>What's Next?</h2>
                                    <p>Next: <strong>Access Modifiers</strong> for controlling visibility!</p>

                                    <div style="margin-top:3rem;">
                                        <% String
                                            prevLinkUrl=request.getContextPath()+"/tutorials/typescript/classes-basics.jsp";String
                                            nextLinkUrl=request.getContextPath()+"/tutorials/typescript/classes-modifiers.jsp";%>
                                            <jsp:include page="../tutorial-nav.jsp">
                                                <jsp:param name="prevLink" value="<%=prevLinkUrl%>" />
                                                <jsp:param name="prevTitle" value="← Class Basics" />
                                                <jsp:param name="nextLink" value="<%=nextLinkUrl%>" />
                                                <jsp:param name="nextTitle" value="Access Modifiers →" />
                                                <jsp:param name="currentLessonId" value="classes-constructor" />
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