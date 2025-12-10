<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "classes-modifiers" );
        request.setAttribute("currentModule", "Classes & OOP" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>TypeScript Access Modifiers | 8gwifi.org</title>
            <meta name="description"
                content="Free TypeScript tutorial: master TypeScript access modifiers: public, private, and protected for encapsulation.">
            <link rel="canonical" href="https://8gwifi.org/tutorials/typescript/classes-modifiers.jsp">
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
        "name": "TypeScript Access Modifiers",
        "description": "Master access modifiers: public, private, and protected.",
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

        <body class="tutorial-body no-preview" data-lesson="classes-modifiers">
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
                                        class="breadcrumb-separator">/</span><span>Access Modifiers</span></nav>
                                <header class="lesson-header">
                                    <h1 class="lesson-title">Access Modifiers</h1>
                                    <div class="lesson-meta"><span>Beginner</span><span>~20 min</span></div>
                                </header>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>
                                <div class="lesson-body">
                                    <p class="lead">Access modifiers control the visibility of class members. TypeScript
                                        provides three modifiers: public, private, and protected for proper
                                        encapsulation.</p>

                                    <img src="<%=request.getContextPath()%>/tutorials/assets/images/ts-access-modifiers.svg"
                                        alt="TypeScript Access Modifiers" class="diagram-image"
                                        style="max-width: 900px; margin: 2rem auto; display: block;">

                                    <h2>Access Modifiers</h2>
                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="typescript/class-access-modifiers.ts" />
                                        <jsp:param name="language" value="typescript" />
                                        <jsp:param name="editorId" value="compiler-modifiers" />
                                    </jsp:include>

                                    <div class="info-box"><strong>Default:</strong> If no modifier is specified, members
                                        are <code>public</code> by default.</div>

                                    <h2>Modifier Comparison</h2>
                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Modifier</th>
                                                <th>Same Class</th>
                                                <th>Child Class</th>
                                                <th>Outside</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><strong>public</strong></td>
                                                <td>✓</td>
                                                <td>✓</td>
                                                <td>✓</td>
                                            </tr>
                                            <tr>
                                                <td><strong>protected</strong></td>
                                                <td>✓</td>
                                                <td>✓</td>
                                                <td>✗</td>
                                            </tr>
                                            <tr>
                                                <td><strong>private</strong></td>
                                                <td>✓</td>
                                                <td>✗</td>
                                                <td>✗</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <h2>When to Use Each Modifier</h2>
                                    <ul>
                                        <li><strong>public:</strong> API methods, properties meant to be accessed
                                            externally</li>
                                        <li><strong>private:</strong> Internal implementation details, sensitive data
                                        </li>
                                        <li><strong>protected:</strong> Properties/methods for inheritance hierarchy
                                        </li>
                                    </ul>

                                    <h2>Common Mistakes</h2>
                                    <div class="mistake-box">
                                        <h4>1. Making Everything Public</h4>
                                        <pre><code class="language-typescript">// ✗ Poor encapsulation
class User {
    public password: string;  // Exposed!
    public internalId: number;  // Should be private
}

// ✓ Proper encapsulation
class User {
    private password: string;
    private internalId: number;
    public userName: string;
}</code></pre>

                                        <h4>2. Using Private When Protected is Needed</h4>
                                        <pre><code class="language-typescript">class Animal {
    private makeSound() {}  // ✗ Child can't override
}

class Dog extends Animal {
    makeSound() {}  // Error!
}

// ✓ Use protected for inheritance
class Animal {
    protected makeSound() {}
}</code></pre>
                                    </div>

                                    <div class="warning-box"><strong>Note:</strong> TypeScript access modifiers are
                                        compile-time only. They don't exist in JavaScript runtime.</div>

                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>public:</strong> Accessible everywhere (default)</li>
                                            <li><strong>private:</strong> Only within the same class</li>
                                            <li><strong>protected:</strong> Same class + child classes</li>
                                            <li>Use private for sensitive data and internal logic</li>
                                        </ul>
                                    </div>

                                    <div style="margin-top:3rem;">
                                        <% String
                                            prevLinkUrl=request.getContextPath()+"/tutorials/typescript/classes-constructor.jsp";String
                                            nextLinkUrl=request.getContextPath()+"/tutorials/typescript/classes-inheritance.jsp";%>
                                            <jsp:include page="../tutorial-nav.jsp">
                                                <jsp:param name="prevLink" value="<%=prevLinkUrl%>" />
                                                <jsp:param name="prevTitle" value="← Constructors" />
                                                <jsp:param name="nextLink" value="<%=nextLinkUrl%>" />
                                                <jsp:param name="nextTitle" value="Inheritance →" />
                                                <jsp:param name="currentLessonId" value="classes-modifiers" />
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